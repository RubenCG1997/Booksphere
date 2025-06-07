import 'package:booksphere/controller/book_controller.dart';
import 'package:booksphere/view/widgets/book_portrait.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controller/review_controller.dart';
import '../../model/book_model.dart';

/// Widget que muestra un carrusel paginado (PageView) con los tres libros mejor valorados.
/// Permite navegar a la página de detalle de cada libro al hacer tap en su portada.
class BookPageview extends StatefulWidget {
  /// ID del usuario actual (opcional).
  final String? uidUser;

  /// Constructor que requiere el [uidUser].
  const BookPageview({super.key, required this.uidUser});

  @override
  State<BookPageview> createState() => _BookPageviewState();
}

class _BookPageviewState extends State<BookPageview> {
  /// Controlador del PageView para manejar páginas y desplazamiento.
  final controller = PageController(initialPage: 0, viewportFraction: 1);

  /// Lista de ISBN de los libros mejor valorados.
  List<String> isbnBetterBooks = [];

  /// Lista de los tres mejores libros cargados.
  List<BookModel> betterBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBetterBooks();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mientras no haya al menos 3 libros cargados, muestra un indicador de carga.
    if (betterBooks.length < 3) {
      return const Center(child: CircularProgressIndicator());
    }

    // Muestra un PageView con las portadas de los tres libros mejor valorados.
    return PageView(
      controller: controller,
      physics: ClampingScrollPhysics(),
      children: [
        // Cada GestureDetector detecta taps para navegar a la página del libro.
        GestureDetector(
          child: BookPortrait(urlImg: betterBooks[0].urlImg),
          onTap: () {
            context.push(
              '/book',
              extra: {'isbn': betterBooks[0].isbn, 'uid': widget.uidUser},
            );
          },
        ),
        GestureDetector(
          child: BookPortrait(urlImg: betterBooks[1].urlImg),
          onTap: () {
            context.push(
              '/book',
              extra: {'isbn': betterBooks[1].isbn, 'uid': widget.uidUser},
            );
          },
        ),
        GestureDetector(
          child: BookPortrait(urlImg: betterBooks[2].urlImg),
          onTap: () {
            context.push(
              '/book',
              extra: {'isbn': betterBooks[2].isbn, 'uid': widget.uidUser},
            );
          },
        ),
      ],
    );
  }

  /// Carga los libros mejor valorados y los libros extra si es necesario para completar 3.
  ///
  /// Obtiene los ISBN de los libros mejor valorados mediante [ReviewController].
  /// Luego, con [BookController], carga los libros correspondientes.
  /// Si no se obtienen 3 libros, agrega libros adicionales para completar la lista.
  Future<void> _loadBetterBooks() async {
    final isbnBooks = await ReviewController().getTopBestIsbnByAverageRating();
    final List<BookModel> books = [];

    if (mounted) {
      // Cargar libros basados en los ISBN mejor valorados
      for (var isbn in isbnBooks) {
        final book = await BookController().getBook(isbn);
        if (book != null) {
          books.add(book);
        }
        if (books.length == 3) {
          break;
        }
      }
    }

    // Si no hay suficientes libros, añadir más para completar 3
    if (books.length < 3 && mounted) {
      final extraBooks = await BookController().getBooks();
      for (var book in extraBooks) {
        if (!books.contains(book)) {
          books.add(book);
        }
        if (books.length == 3) {
          break;
        }
      }
    }

    // Actualizar el estado con los libros cargados
    if (mounted) {
      setState(() {
        betterBooks = books;
      });
    }
  }
}
