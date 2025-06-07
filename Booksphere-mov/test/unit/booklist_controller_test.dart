import 'package:booksphere/model/book_model.dart';
import 'package:booksphere/model/booklists_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Controlador para gestionar las listas personalizadas de libros de los usuarios.
class BookListsController {
  // Instancia de Firestore para acceder a la base de datos.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene todas las listas de libros asociadas a un usuario.
  Future<List<BookLists>> getBookLists(String uid) async {
    final snapshot =
    await _db.collection('booklists').where('idUser', isEqualTo: uid).get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) => BookLists.fromMap(doc.data())).toList();
    } else {
      return [];
    }
  }

  /// Crea una nueva lista de libros para un usuario.
  Future<void> createBookList(String uidUser, String name, String isbn) async {
    DateTime now = DateTime.now();
    String date = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    ).toString();

    final collection = _db.collection('booklists');

    final ref = {
      'idUser': uidUser,
      'name': name,
      'idBook': [isbn],
      'dateCreation': date,
    };

    DocumentReference docRef = await collection.add(ref);
    await docRef.update({'id': docRef.id});
  }

  /// Añade un libro a una lista de usuario si no existe ya en ella.
  Future<void> addBookToList(String uidUser, String name, String isbn) async {
    final snapshot = await _db
        .collection('booklists')
        .where('idUser', isEqualTo: uidUser)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docRef = snapshot.docs.first.reference;
      final bookList = BookLists.fromMap(snapshot.docs.first.data());

      if (!bookList.idBook.contains(isbn)) {
        await docRef.update({
          'idBook': FieldValue.arrayUnion([isbn]),
        });
      }
    }
  }

  /// Elimina un libro de una lista de usuario.
  Future<void> removeBookFromList(String uidUser, String name, String isbn) async {
    final snapshot = await _db
        .collection('booklists')
        .where('idUser', isEqualTo: uidUser)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docRef = snapshot.docs.first.reference;

      await docRef.update({
        'idBook': FieldValue.arrayRemove([isbn]),
      });
    }
  }

  /// Obtiene todos los libros de una lista específica de un usuario.
  Future<List<BookModel>> getBooksFromList(String uidUser, String name) async {
    final snapshot = await _db
        .collection('booklists')
        .where('idUser', isEqualTo: uidUser)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final bookList = BookLists.fromMap(snapshot.docs.first.data());

      final books = await Future.wait(
        bookList.idBook.map((isbn) async {
          final bookSnapshot = await _db
              .collection('books')
              .where('isbn', isEqualTo: isbn)
              .get();

          if (bookSnapshot.docs.isNotEmpty) {
            return BookModel.fromMap(bookSnapshot.docs.first.data());
          } else {
            return null;
          }
        }),
      );

      return books.whereType<BookModel>().toList();
    } else {
      return [];
    }
  }

  /// Elimina una lista de libros de un usuario.
  Future<void> deleteList(String uidUser, String name) async {
    final snapshot = await _db
        .collection('booklists')
        .where('idUser', isEqualTo: uidUser)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docRef = snapshot.docs.first.reference;
      await docRef.delete();
    }
  }

  /// Busca un libro por su URL de EPUB.
  Future<BookModel?> getBookbyUrl(String urlEpub) async {
    final snapshot = await _db
        .collection('books')
        .where('urlEpub', isEqualTo: urlEpub)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return BookModel.fromMap(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  /// Actualiza el nombre de una lista existente.
  Future<void> updateListName(String uidUser, String name, String newName) async {
    final snapshot = await _db
        .collection('booklists')
        .where('idUser', isEqualTo: uidUser)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docRef = snapshot.docs.first.reference;
      await docRef.update({'name': newName});
    }
  }

  /// Ejemplo: obtener listas de usuario
  static Future<void> exampleGetBookLists(BookListsController controller) async {
    var listas = await controller.getBookLists('usuario123');
    print('Listas encontradas: ${listas.length}');
  }

  /// Ejemplo: crear lista nueva
  static Future<void> exampleCreateBookList(BookListsController controller) async {
    await controller.createBookList('usuario123', 'Favoritos', '9781234567897');
    print('Lista creada');
  }

  /// Ejemplo: añadir libro a lista
  static Future<void> exampleAddBookToList(BookListsController controller) async {
    await controller.addBookToList('usuario123', 'Favoritos', '9789876543210');
    print('Libro añadido a la lista');
  }

  /// Ejemplo: eliminar libro de lista
  static Future<void> exampleRemoveBookFromList(BookListsController controller) async {
    await controller.removeBookFromList('usuario123', 'Favoritos', '9789876543210');
    print('Libro eliminado de la lista');
  }

  /// Ejemplo: obtener libros de una lista
  static Future<void> exampleGetBooksFromList(BookListsController controller) async {
    var libros = await controller.getBooksFromList('usuario123', 'Favoritos');
    print('Libros en la lista: ${libros.length}');
  }

  /// Ejemplo: eliminar lista
  static Future<void> exampleDeleteList(BookListsController controller) async {
    await controller.deleteList('usuario123', 'Favoritos');
    print('Lista eliminada');
  }

  /// Ejemplo: buscar libro por URL EPUB
  static Future<void> exampleGetBookByUrl(BookListsController controller) async {
    var libro = await controller.getBookbyUrl('https://ejemplo.com/libro.epub');
    if (libro != null) {
      print('Libro encontrado: ${libro.title}');
    } else {
      print('No se encontró el libro');
    }
  }

  /// Ejemplo: actualizar nombre de lista
  static Future<void> exampleUpdateListName(BookListsController controller) async {
    await controller.updateListName('usuario123', 'Favoritos', 'Favoritos 2025');
    print('Nombre de lista actualizado');
  }
}
