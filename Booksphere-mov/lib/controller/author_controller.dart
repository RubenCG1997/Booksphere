import 'package:cloud_firestore/cloud_firestore.dart';

/// Controlador para gestionar la obtención de información de autores desde Firestore.
///
/// Actualmente incluye:
/// - Obtener el nombre del autor por su UID.
class AuthorController {
  // Instancia de FirebaseFirestore para acceder a la base de datos.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene el nombre del autor desde la colección 'authors' usando su UID.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del autor.
  ///
  /// Retorna:
  /// - El nombre del autor si existe, o `null` si no existe o ocurre un error.
  Future<String?> getNameAuthor(String uid) async {
    try {
      final doc = await _db.collection('authors').doc(uid).get();

      // Verifica si el documento existe antes de intentar acceder a sus datos.
      if (doc.exists) {
        return doc.data()?['name']; // Se usa `?` por seguridad adicional.
      } else {
        return null; // El documento no fue encontrado.
      }
    } catch (e) {
      print('Error al obtener el nombre del autor: $e');
      return null;
    }
  }
}
