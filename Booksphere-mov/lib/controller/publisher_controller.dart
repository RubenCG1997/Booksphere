import 'package:cloud_firestore/cloud_firestore.dart';

/// Controlador para gestionar la obtención de datos de editoriales desde Firestore.
class PublisherController {
  // Instancia de Firestore para interactuar con la base de datos.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene el nombre de una editorial a partir de su ID.
  ///
  /// Parámetro:
  /// - [idPublisher]: ID del documento de la editorial en Firestore.
  ///
  /// Retorna:
  /// - Un [String] con el nombre de la editorial si existe, o `null` en caso contrario.
  Future<String?> getNamePublisher(String idPublisher) async {
    try {
      // Consulta el documento con el ID especificado.
      final doc = await _db.collection('publisher').doc(idPublisher).get();

      // Si el documento existe, retorna el nombre.
      if (doc.exists) {
        return doc.data()!['name'];
      } else {
        return null;
      }
    } catch (e) {
      // En caso de error (por ejemplo, fallo de red), retorna null de forma segura.
      return null;
    }
  }
}
