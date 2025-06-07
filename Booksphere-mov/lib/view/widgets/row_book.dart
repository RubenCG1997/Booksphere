import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controller/book_controller.dart';
import '../../controller/booklists_controller.dart';
import '../../core/color.dart';
import '../../model/book_model.dart';
import 'book_portrait.dart';

/// Widget que representa una fila con información de un libro,
/// incluyendo su imagen, título y una acción que depende del modo de edición.
///
/// Si `edit` es `false`, se muestra un botón para navegar al detalle del libro.
/// Si `edit` es `true`, se muestra un botón para eliminar el libro de la lista.
class RowBook extends StatefulWidget {
  /// Modelo del libro a mostrar.
  final BookModel bookModel;

  /// UID del usuario actual.
  final String? uidUser;

  /// Callback que se ejecuta cuando se elimina un libro de la lista.
  final VoidCallback? onListDeleted;

  /// Nombre de la lista en la que se encuentra el libro.
  final String? nameList;

  /// Indica si el widget está en modo edición (permite eliminar).
  final bool edit;

  /// Constructor del widget.
  const RowBook({
    super.key,
    required this.uidUser,
    required this.nameList,
    required this.bookModel,
    required this.onListDeleted,
    required this.edit,
  });

  @override
  State<RowBook> createState() => _RowBookState();
}

class _RowBookState extends State<RowBook> {
  /// Modelo del libro cargado desde la base de datos.
  BookModel book = BookModel.empty();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    book = BookModel.empty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Imagen de portada del libro.
              SizedBox(
                height: size.height * 0.15,
                child: BookPortrait(urlImg: widget.bookModel.urlImg),
              ),

              /// Título del libro.
              Text(
                widget.bookModel.title,
                style: const TextStyle(
                  color: AppColor.textColor,
                  fontSize: 14,
                  fontFamily: 'Merriweather',
                ),
              ),

              /// Acción según el modo (ver o eliminar).
              !widget.edit
                  ? IconButton(
                icon: const Icon(
                  Icons.chrome_reader_mode_outlined,
                  color: AppColor.textColor,
                  size: 40,
                ),
                onPressed: () async {
                  final result = await context.push(
                    '/book',
                    extra: {
                      'isbn': widget.bookModel.isbn,
                      'uid': widget.uidUser,
                    },
                  );
                  if (result != null) {
                    widget.onListDeleted?.call();
                  }
                },
              )
                  : IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColor.textColor,
                  size: 40,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Eliminar de la lista'),
                      content: const Text(
                        '¿Está seguro de eliminar este libro de la lista?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await BookListsController()
                                .removeBookFromList(
                              widget.uidUser!,
                              widget.nameList!,
                              widget.bookModel.isbn,
                            );
                            widget.onListDeleted?.call();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Sí'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Metodo que inicia la carga de datos del libro.
  Future<void> _initializeData() async {
    _loadBook();
  }

  /// Carga los datos del libro desde el controlador usando su ISBN.
  Future<void> _loadBook() async {
    final bookModel = await BookController().getBook(widget.bookModel.isbn);
    if (mounted && bookModel != null) {
      setState(() {
        book = bookModel;
      });
    }
  }
}
