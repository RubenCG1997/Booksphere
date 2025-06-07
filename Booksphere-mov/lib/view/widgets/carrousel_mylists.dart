import 'package:booksphere/model/booklists_model.dart';
import 'package:booksphere/view/widgets/book_portrait.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/color.dart';
import '../../model/book_model.dart';

/// Widget que muestra un carrusel horizontal de libros pertenecientes a una lista personal del usuario.
///
/// Parámetros:
/// - [bookLists]: Objeto que representa la lista de libros (nombre, id).
/// - [uid]: ID del usuario actual.
/// - [books]: Lista de libros que pertenecen a la lista mostrada.
/// - [onBookDeleted]: Callback que se llama cuando se detecta que un libro fue eliminado
///   tras regresar de la vista detalle o lista completa.
class CarrouselMylists extends StatefulWidget {
  final BookLists bookLists;
  final String? uid;
  final List<BookModel> books;
  final VoidCallback? onBookDeleted;

  const CarrouselMylists({
    super.key,
    required this.bookLists,
    required this.uid,
    required this.books,
    this.onBookDeleted,
  });

  @override
  State<CarrouselMylists> createState() => _CarrouselMylistsState();
}

class _CarrouselMylistsState extends State<CarrouselMylists> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con el nombre de la lista y opción "Ver todo"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.bookLists.name,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 16,
                    fontFamily: 'Merriweather',
                  ),
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        'Ver todo',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: 16,
                          fontFamily: 'Merriweather',
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.textColor,
                        size: 16,
                      ),
                    ],
                  ),
                  // Navega a la vista completa de la lista, y refresca si hubo cambios.
                  onTap: () async {
                    final result = await context.push(
                      '/booklist',
                      extra: {
                        'uid': widget.uid,
                        'name': widget.bookLists.name,
                        'idBooklists': widget.bookLists.id,
                      },
                    );
                    if (result != null) {
                      widget.onBookDeleted?.call();
                    }
                  },
                ),
              ],
            ),
            // Carrusel horizontal con las portadas de los libros
            SizedBox(
              height: size.height * 0.2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.books.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: BookPortrait(urlImg: widget.books[index].urlImg),
                        onTap: () async {
                          // Navega a detalle del libro y refresca si se detectan cambios
                          final result = await context.push(
                            '/book',
                            extra: {
                              'isbn': widget.books[index].isbn,
                              'uid': widget.uid,
                            },
                          );
                          if (result != null) {
                            widget.onBookDeleted?.call();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
