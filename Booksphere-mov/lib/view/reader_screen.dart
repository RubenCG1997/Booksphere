import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_file/internet_file.dart';

import '../controller/book_controller.dart';
import '../controller/user_controller.dart';

/// Pantalla de lectura de libros en formato EPUB.
///
/// Utiliza `epub_view` para mostrar contenido EPUB desde una URL.
/// Guarda y recupera la última posición leída del usuario.
class Reader extends StatefulWidget {
  /// URL del archivo EPUB a leer.
  final String urlEpub;

  /// UID del usuario que está leyendo el libro.
  final String uidUser;

  const Reader({
    super.key,
    required this.urlEpub,
    required this.uidUser,
  });

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  /// Controlador de la vista EPUB.
  EpubController? _epubController;

  @override
  void initState() {
    super.initState();
    _loadEpub(); // Cargar el archivo EPUB al iniciar.
  }

  @override
  void dispose() {
    _epubController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar indicador de carga mientras se prepara el lector.
    if (_epubController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: EpubViewActualChapter(
          controller: _epubController!,
          builder: (chapterValue) => Text(
            chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
            textAlign: TextAlign.start,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
        ],
      ),

      // Menú lateral con tabla de contenido
      drawer: Drawer(
        child: EpubViewTableOfContents(controller: _epubController!),
      ),

      // Vista principal del libro
      body: EpubView(controller: _epubController!),
    );
  }

  /// Carga el archivo EPUB desde la URL y restaura la última posición del usuario.
  Future<void> _loadEpub() async {
    // Buscar el libro por su URL
    final book = await BookController().getBookbyUrl(widget.urlEpub);
    if (book == null) return;

    // Obtener última posición leída
    final lastPosition = await UserController().getLastChapter(
      widget.uidUser,
      book.isbn,
    );

    // Crear controlador EPUB
    final epub = EpubController(
      document: EpubDocument.openData(await InternetFile.get(widget.urlEpub)),
      epubCfi: lastPosition.isEmpty ? null : lastPosition,
    );

    // Guardar nueva posición cada vez que cambie
    epub.currentValueListenable.addListener(() async {
      final newPosition = epub.generateEpubCfi();
      if (newPosition != null) {
        await UserController().saveLastPosition(
          widget.uidUser,
          book.isbn,
          newPosition,
        );
      }
    });

    // Actualizar el estado si el widget sigue montado
    if (mounted) {
      setState(() {
        _epubController = epub;
      });
    }
  }
}
