import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controller/book_controller.dart';
import '../../controller/user_controller.dart';
import '../../core/color.dart';
import '../../model/book_model.dart';
import 'book_portrait.dart';

/// Widget que muestra un carrusel horizontal de libros basado en un género
/// o en los libros leídos por un usuario.
///
/// Parámetros:
/// - [uid]: ID del usuario, para mostrar sus libros leídos si no se especifica un género.
/// - [genre]: Género para filtrar libros (opcional).
/// - [titleCarrousel]: Título del carrusel para mostrar arriba.
/// - [onRefresh]: Callback que se ejecuta al volver de la página de detalle de un libro,
///   para refrescar la lista si es necesario.
class CarrouselHome extends StatefulWidget {
  final String? uid;
  final String? genre;
  final String? titleCarrousel;
  final VoidCallback? onRefresh;

  const CarrouselHome({
    super.key,
    required this.titleCarrousel,
    required this.uid,
    required this.genre,
    this.onRefresh,
  });

  @override
  State<CarrouselHome> createState() => _CarrouselHomeState();
}

class _CarrouselHomeState extends State<CarrouselHome> {
  /// Lista de libros que se mostrarán en el carrusel.
  late List<BookModel> listBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void dispose() {
    super.dispose();
    listBooks = [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Si no hay libros, no se muestra nada.
    if (listBooks.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del carrusel
          Text(
            widget.titleCarrousel!,
            style: TextStyle(color: AppColor.textColor, fontSize: 16),
          ),
          // Lista horizontal de libros
          SizedBox(
            height: size.height * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: listBooks.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: BookPortrait(urlImg: listBooks[index].urlImg),
                    onTap: () {
                      // Navega a la página del libro y refresca si vuelve
                      context.push(
                        '/book',
                        extra: {
                          'isbn': listBooks[index].isbn,
                          'uid': widget.uid,
                        },
                      ).then((_) {
                        if (widget.onRefresh != null) {
                          widget.onRefresh!();
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Carga la lista de libros según el género o los libros leídos por el usuario.
  Future<void> _loadBooks() async {
    List<BookModel> books = [];

    // Si no hay género, carga los libros leídos por el usuario (máximo 5)
    if ((widget.genre ?? '').isEmpty && (widget.uid ?? '').isNotEmpty) {
      final allReadBooks = await UserController().getReaderBooks(widget.uid!);
      // Ordena por ISBN descendente y toma 5
      allReadBooks.sort((a, b) => b.isbn.compareTo(a.isbn));
      books = allReadBooks.take(5).toList();

    }
    // Si hay género, carga libros filtrados por género
    else if ((widget.genre ?? '').isNotEmpty) {
      books = await BookController().getBooksGenre(widget.genre!);
    }

    // Actualiza el estado solo si el widget sigue montado y hay libros
    if (mounted && books.isNotEmpty) {
      setState(() {
        listBooks = books;
      });
    }
  }
}
