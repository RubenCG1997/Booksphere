import 'package:booksphere/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Controlador para gestionar operaciones relacionadas con libros en Firestore.
class BookController {
  // Instancia de Firestore para acceder a la base de datos de libros.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene un libro por su ISBN desde Firestore.
  ///
  /// Parámetro:
  /// - [isbn]: Código ISBN del libro a buscar.
  ///
  /// Retorna:
  /// - Una instancia de [BookModel] si se encuentra, o `null` si no existe o hay error.
  Future<BookModel?> getBook(String isbn) async {
    try {
      final doc = await _db.collection('books').doc(isbn).get();
      if (doc.exists) {
        return BookModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error al obtener el libro por ISBN: $e');
      return null;
    }
  }

  /// Obtiene todos los libros de un género específico.
  ///
  /// Parámetro:
  /// - [genre]: Género literario.
  ///
  /// Retorna:
  /// - Una lista de libros del género dado, vacía si no se encuentran coincidencias.
  Future<List<BookModel>> getBooksGenre(String genre) async {
    final snapshot =
        await _db.collection('books').where('genre', isEqualTo: genre).get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } else {
      return [];
    }
  }

  /// Obtiene todos los libros disponibles en la base de datos.
  ///
  /// Retorna:
  /// - Una lista de todos los libros, o una lista vacía si no hay libros.
  Future<List<BookModel>> getBooks() async {
    final snapshot = await _db.collection('books').get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } else {
      return [];
    }
  }

  /// Busca libros por coincidencia parcial en el título.
  ///
  /// Parámetro:
  /// - [title]: Título del libro a buscar.
  ///
  /// Retorna:
  /// - Lista de libros cuyo título empieza por el texto dado.
  Future<List<BookModel>> getBooksByTitle(String title) async {
    /// Capitaliza el título ingresado (ej. "harry" → "Harry").
    String capitalice(String text) {
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

    final localTitle = capitalice(title);

    final snapshot =
        await _db
            .collection('books')
            .orderBy('title')
            .startAt([localTitle])
            .endAt(['$localTitle\uf8ff']) // Rango para búsqueda por prefijo
            .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList();
    } else {
      return [];
    }
  }

  /// Obtiene un libro a partir de su URL de archivo EPUB.
  ///
  /// Parámetro:
  /// - [urlEpub]: URL del archivo EPUB del libro.
  ///
  /// Retorna:
  /// - Una instancia de [BookModel] si se encuentra, o `null` si no existe.
  Future<BookModel?> getBookbyUrl(String urlEpub) async {
    final snapshot =
        await _db
            .collection('books')
            .where('urlEpub', isEqualTo: urlEpub)
            .get();

    if (snapshot.docs.isNotEmpty) {
      return BookModel.fromMap(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  Future<List<String>> getGenres() async {
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
    final genres = <String>{};

    for (var doc in snapshot.docs) {
      final genre = doc['genre'];
      if (genre != null && genre.toString().trim().isNotEmpty) {
        genres.add(genre.toString().trim());
      }
    }

    final sortedGenres = genres.toList()..sort();
    return ['Todos', ...sortedGenres];
  }
}
