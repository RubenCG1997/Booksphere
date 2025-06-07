import 'package:booksphere/model/book_model.dart';
import 'package:booksphere/model/booklists_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Controlador para gestionar las listas personalizadas de libros de los usuarios.
class BookListsController {
  // Instancia de Firestore para acceder a la base de datos.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene todas las listas de libros asociadas a un usuario.
  ///
  /// Parámetro:
  /// - [uid]: ID del usuario.
  ///
  /// Retorna:
  /// - Una lista de objetos [BookLists].
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
  ///
  /// Parámetros:
  /// - [uidUser]: ID del usuario.
  /// - [name]: Nombre de la lista.
  /// - [isbn]: ISBN del primer libro a añadir.
  Future<void> createBookList(String uidUser, String name, String isbn) async {
    // Se genera un timestamp para registrar la fecha de creación.
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

    // Se añade el documento y se actualiza el campo `id` con el ID generado automáticamente.
    DocumentReference docRef = await collection.add(ref);
    await docRef.update({'id': docRef.id});
  }

  /// Añade un libro a una lista de usuario si no existe ya en ella.
  ///
  /// Parámetros:
  /// - [uidUser]: ID del usuario.
  /// - [name]: Nombre de la lista.
  /// - [isbn]: ISBN del libro a añadir.
  Future<void> addBookToList(String uidUser, String name, String isbn) async {
    final snapshot = await _db
        .collection('booklists')
        .where('idUser', isEqualTo: uidUser)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docRef = snapshot.docs.first.reference;
      final bookList = BookLists.fromMap(snapshot.docs.first.data());

      // Añade el ISBN solo si no está ya presente.
      if (!bookList.idBook.contains(isbn)) {
        await docRef.update({
          'idBook': FieldValue.arrayUnion([isbn]),
        });
      }
    }
  }

  /// Elimina un libro de una lista de usuario.
  ///
  /// Parámetros:
  /// - [uidUser]: ID del usuario.
  /// - [name]: Nombre de la lista.
  /// - [isbn]: ISBN del libro a eliminar.
  Future<void> removeBookFromList(
      String uidUser,
      String name,
      String isbn,
      ) async {
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
  ///
  /// Parámetros:
  /// - [uidUser]: ID del usuario.
  /// - [name]: Nombre de la lista.
  ///
  /// Retorna:
  /// - Lista de objetos [BookModel] que forman parte de la lista.
  Future<List<BookModel>> getBooksFromList(String uidUser, String name) async {
    final snapshot = await _db
        .collection('booklists')
        .where('idUser', isEqualTo: uidUser)
        .where('name', isEqualTo: name)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final bookList = BookLists.fromMap(snapshot.docs.first.data());

      // Se buscan todos los libros por su ISBN usando llamadas en paralelo.
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

      return books.whereType<BookModel>().toList(); // Elimina los nulos.
    } else {
      return [];
    }
  }

  /// Elimina una lista de libros de un usuario.
  ///
  /// Parámetros:
  /// - [uidUser]: ID del usuario.
  /// - [name]: Nombre de la lista.
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
  ///
  /// Parámetro:
  /// - [urlEpub]: URL del archivo EPUB.
  ///
  /// Retorna:
  /// - Un objeto [BookModel] o `null` si no existe.
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
  ///
  /// Parámetros:
  /// - [uidUser]: ID del usuario.
  /// - [name]: Nombre actual de la lista.
  /// - [newName]: Nuevo nombre para la lista.
  Future<void> updateListName(
      String uidUser,
      String name,
      String newName,
      ) async {
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
}
