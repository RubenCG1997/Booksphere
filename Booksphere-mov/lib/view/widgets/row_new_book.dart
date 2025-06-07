import 'package:flutter/material.dart';

import '../../controller/book_controller.dart';
import '../../controller/booklists_controller.dart';
import '../../model/book_model.dart';
import 'book_portrait.dart';

/// Widget que muestra una lista de libros que aún no están en una lista dada,
/// permitiendo añadirlos a dicha lista.
///
/// Filtra los libros en función del texto ingresado en el [controller].
class RowNewBook extends StatefulWidget {
  /// UID del usuario actual.
  final String? uidUser;

  /// Nombre de la lista donde se añadirán libros.
  final String? nameList;

  /// Controlador para escuchar cambios en el campo de búsqueda.
  final TextEditingController? controller;

  /// Callback que se ejecuta cuando se añade un libro a la lista.
  final VoidCallback? onListDeleted;

  /// Constructor del widget.
  const RowNewBook({
    super.key,
    required this.uidUser,
    required this.nameList,
    required this.controller,
    required this.onListDeleted,
  });

  @override
  State<RowNewBook> createState() => _RowNewBookState();
}

class _RowNewBookState extends State<RowNewBook> {
  /// Lista de libros que ya están en la lista del usuario.
  List<BookModel> booksFromList = [];

  /// Lista completa de libros disponibles.
  List<BookModel> allBooks = [];

  /// Lista filtrada de libros que NO están en la lista y coinciden con el filtro.
  List<BookModel> booksNotInList = [];

  @override
  void initState() {
    super.initState();
    // Agregar listener para detectar cambios en el texto del filtro
    widget.controller!.addListener(_loadFilteredBooks);
    // Cargar libros filtrados inicialmente
    _loadFilteredBooks();
  }

  @override
  void dispose() {
    // Remover listener al destruir el widget para evitar fugas de memoria
    widget.controller!.removeListener(_loadFilteredBooks);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ListView.builder(
      itemCount: booksNotInList.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Imagen de portada del libro.
                SizedBox(
                  height: size.height * 0.15,
                  child: BookPortrait(urlImg: booksNotInList[index].urlImg),
                ),

                /// Título del libro.
                Text(
                  booksNotInList[index].title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Merriweather',
                  ),
                ),

                /// Botón para añadir el libro a la lista.
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black, size: 25),
                  onPressed: () async {
                    // Añadir libro a la lista en el backend
                    await BookListsController().addBookToList(
                      widget.uidUser!,
                      widget.nameList!,
                      booksNotInList[index].isbn,
                    );

                    // Ejecutar callback externo para actualizar UI si existe
                    widget.onListDeleted?.call();

                    // Actualizar listas locales para reflejar el cambio
                    booksFromList.add(booksNotInList[index]);
                    booksNotInList.removeAt(index);

                    setState(() {
                      // Actualizar estado con nuevas listas
                      booksNotInList = booksNotInList;
                      booksFromList = booksFromList;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Carga y filtra los libros disponibles que no están en la lista,
  /// y que coinciden con el texto ingresado en el campo de búsqueda.
  Future<void> _loadFilteredBooks() async {
    // Obtener libros ya en la lista
    final booksFromList = await BookListsController().getBooksFromList(
      widget.uidUser!,
      widget.nameList!,
    );

    // Obtener todos los libros disponibles
    final allBooks = await BookController().getBooks();

    // Crear lista de ISBNs de libros que ya están en la lista
    final isbnList = booksFromList.map((book) => book.isbn).toList();

    // Filtrar libros que NO están en la lista
    final allBooksFiltered = allBooks.where((book) {
      return !isbnList.contains(book.isbn);
    }).toList();

    // Filtrar por texto en el título si existe
    final title = widget.controller!.text.trim();
    if (title.isNotEmpty) {
      allBooksFiltered.retainWhere((book) {
        return book.title.toLowerCase().contains(title.toLowerCase());
      });
    }

    if (mounted) {
      setState(() {
        this.booksNotInList = allBooksFiltered;
        this.allBooks = allBooksFiltered;
        this.booksFromList = booksFromList;
      });
    }
  }
}
