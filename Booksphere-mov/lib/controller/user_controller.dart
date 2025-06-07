import 'package:booksphere/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/subsciption_type.dart';
import '../model/user_model.dart';
import '../service/auth_service.dart';

/// Controlador de usuario que gestiona autenticación, creación y manipulación
/// de datos del usuario en Firestore.
class UserController {
  final _db = FirebaseFirestore.instance;
  final _AuthCredential = AuthService();

  /// Crea un usuario con correo y contraseña.
  ///
  /// Parámetros:
  /// - [context] → Contexto de la aplicación (para mostrar mensajes).
  /// - [email] → Correo electrónico del usuario.
  /// - [password] → Contraseña del usuario.
  /// - [username] → Nombre de usuario.
  /// - [subscription] → Tipo de suscripción (FREE, PREMIUM, etc).
  ///
  /// Retorna:
  /// - `true` si el usuario fue creado correctamente.
  /// - `false` si hubo un error (por ejemplo, email ya existente).
  Future<bool> createWithEmail(
      BuildContext context,
      String email,
      password,
      username,
      subscription,
      ) async {
    try {
      User? user = await _AuthCredential.createUser(email, password);
      if (user != null) {
        UserModel userModel = UserModel.createUser(
          user.uid.toString(),
          email,
          username,
          subscription,
        );
        await _db.collection('users').doc(user.uid).set(userModel.toMap());

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear el usuario, correo ya existente'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  /// Inicia sesión con Google.
  ///
  /// Si es un nuevo usuario, se crea automáticamente en Firestore con sus datos básicos.
  ///
  /// Retorna:
  /// - `uid` del usuario si el inicio fue exitoso.
  /// - `null` en caso de error.
  Future<String?> signInWithGoogle() async {
    try {
      User user = (await _AuthCredential.signInWithGoogle());

      final userDoc = await _db.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        UserModel userModel = UserModel.createWithGoogle(
          user.uid.toString(),
          user.email.toString(),
          user.displayName.toString(),
          SubcriptionType.FREE.toString(),
        );
        await _db.collection('users').doc(user.uid).set(userModel.toMap());
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user.uid);

      return user.uid.toString();
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Inicia sesión con correo y contraseña.
  ///
  /// Parámetros:
  /// - [email] → Correo electrónico.
  /// - [password] → Contraseña.
  /// - [context] → Contexto para mostrar mensajes.
  ///
  /// Retorna:
  /// - `uid` del usuario si el inicio fue exitoso.
  /// - `null` si las credenciales son inválidas.
  Future<String?> login(
      String email,
      String password,
      BuildContext context,
      ) async {
    try {
      String? uidUser = await AuthService().signInEAndP(email, password);

      if (uidUser != null && uidUser.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uidUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inicio de sesión exitoso'),
            backgroundColor: Colors.green,
          ),
        );
        return uidUser;
      } else {
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credenciales erróneas'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  /// Envía un correo para recuperar contraseña.
  ///
  /// Parámetro:
  /// - [email] → Email al que se enviará la solicitud.
  ///
  /// Retorna:
  /// - `true` si se envió correctamente.
  /// - `false` si hubo un error.
  Future<bool> recoverPassword(String email) async {
    try {
      await _AuthCredential.recoverPassword(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene todos los usuarios excepto el actual.
  ///
  /// Parámetro:
  /// - [idUser] → ID del usuario actual.
  ///
  /// Retorna:
  /// - Lista de `UserModel` de otros usuarios.
  Future<List<UserModel>> getAllUsers(String idUser) async {
    final querySnapshot = await _db.collection('users').get();
    List<UserModel> users = [];

    for (var doc in querySnapshot.docs) {
      if (doc.id != idUser) {
        users.add(UserModel.fromMap(doc.data()));
      }
    }
    return users;
  }

  /// Obtiene la información de un usuario por su UID.
  ///
  /// Parámetro:
  /// - [uid] → UID del usuario.
  ///
  /// Retorna:
  /// - Objeto `UserModel` si existe, `null` si no.
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Guarda la última posición leída por el usuario en un libro.
  ///
  /// Parámetros:
  /// - [uid] → ID del usuario.
  /// - [isbn] → ISBN del libro.
  /// - [position] → Última posición o capítulo leído.
  Future<void> saveLastPosition(
      String uid,
      String isbn,
      String position,
      ) async {
    await _db.collection('users').doc(uid).update({
      'readerBooks.$isbn': position,
    });
  }

  /// Obtiene el último capítulo leído por el usuario de un libro.
  ///
  /// Parámetros:
  /// - [uid] → ID del usuario.
  /// - [isbn] → ISBN del libro.
  ///
  /// Retorna:
  /// - String con la posición/chapter o cadena vacía si no existe.
  Future<String> getLastChapter(String uid, String isbn) {
    return _db.collection('users').doc(uid).get().then((doc) {
      if (doc.exists) {
        final readerBooks = doc.data()!['readerBooks'] as Map<String, dynamic>;
        return readerBooks[isbn] ?? '';
      } else {
        return '';
      }
    });
  }

  /// Obtiene los IDs de los usuarios que siguen al usuario especificado.
  ///
  /// Parámetro:
  /// - [uid] → ID del usuario.
  ///
  /// Retorna:
  /// - Lista de IDs de seguidores.
  Future<List<String>> getFollowersIdUsers(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return List<String>.from(doc.data()!['followers']);
    } else {
      return [];
    }
  }

  /// Obtiene los IDs de los usuarios que el usuario sigue.
  ///
  /// Parámetro:
  /// - [uid] → ID del usuario.
  ///
  /// Retorna:
  /// - Lista de IDs de seguidos.
  Future<List<String>> getFollowsIdUsers(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return List<String>.from(doc.data()!['follows']);
    } else {
      return [];
    }
  }

  /// Obtiene la lista de libros que el usuario ha leído.
  ///
  /// Parámetro:
  /// - [uid] → ID del usuario.
  ///
  /// Retorna:
  /// - Lista de objetos `BookModel` de los libros leídos.
  Future<List<BookModel>> getReaderBooks(String uid) async {
    final userDoc = await _db.collection('users').doc(uid).get();
    if (!userDoc.exists) return [];

    final Map<String, dynamic>? readerBooksMap =
    userDoc.data()?['readerBooks'] as Map<String, dynamic>?;

    if (readerBooksMap == null || readerBooksMap.isEmpty) return [];

    List<BookModel> books = [];

    for (String isbn in readerBooksMap.keys) {
      final bookDoc = await _db.collection('books').doc(isbn).get();
      if (bookDoc.exists) {
        books.add(BookModel.fromMap(bookDoc.data()!));
      }
    }
    return books;
  }

  /// Sigue a otro usuario.
  ///
  /// Parámetros:
  /// - [uid] → ID del usuario actual.
  /// - [userId] → ID del usuario a seguir.
  Future<void> followUser(String uid, String userId) async {
    await _db.collection('users').doc(uid).update({
      'follows': FieldValue.arrayUnion([userId]),
    });
    await _db.collection('users').doc(userId).update({
      'followers': FieldValue.arrayUnion([uid]),
    });
  }

  /// Deja de seguir a un usuario.
  ///
  /// Parámetros:
  /// - [uid] → ID del usuario actual.
  /// - [userId] → ID del usuario a dejar de seguir.
  Future<void> unfollowUser(String uid, String userId) async {
    await _db.collection('users').doc(uid).update({
      'follows': FieldValue.arrayRemove([userId]),
    });

    await _db.collection('users').doc(userId).update({
      'followers': FieldValue.arrayRemove([uid]),
    });
  }

  /// Actualiza la información general del usuario.
  ///
  /// Parámetro:
  /// - [user] → Objeto `UserModel` actualizado.
  Future<void> updateUser(UserModel? user) async {
    if (user == null) return;
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  /// Actualiza el tipo de suscripción del usuario.
  ///
  /// Parámetros:
  /// - [uid] → ID del usuario.
  /// - [subscription] → Nuevo tipo de suscripción.
  Future<void> updateSubscription(String uid, String subscription) async {
    await _db.collection('users').doc(uid).update({
      'subscription': subscription,
    });
  }
}
