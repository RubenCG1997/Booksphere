import 'package:booksphere/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/review_model.dart';

/// Controlador encargado de manejar las operaciones relacionadas con reseñas
/// de libros en Firestore.
class ReviewController {
  final _db = FirebaseFirestore.instance;

  /// Obtiene todas las reseñas de un libro según su ISBN.
  ///
  /// Parámetros:
  /// - [isbn] → Código ISBN del libro.
  ///
  /// Retorna:
  /// - Lista de objetos `ReviewModel` asociados al libro.
  Future<List<ReviewModel>> getReviews(String isbn) async {
    List<ReviewModel> reviews = [];

    final querySnapshot =
    await _db.collection('reviews').where('idBook', isEqualTo: isbn).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        final review = ReviewModel.fromMap(doc.data());
        reviews.add(review);
      }
    }
    return reviews;
  }

  /// Obtiene una reseña por su ID.
  ///
  /// Parámetros:
  /// - [idReview] → ID del documento de la reseña.
  ///
  /// Retorna:
  /// - Objeto `ReviewModel`, o `ReviewModel.empty()` si no existe o ocurre un error.
  Future<ReviewModel> getReview(String idReview) async {
    try {
      final doc = await _db.collection('reviews').doc(idReview).get();
      if (doc.exists) {
        return ReviewModel.fromMap(doc.data()!);
      } else {
        return ReviewModel.empty();
      }
    } catch (e) {
      return ReviewModel.empty();
    }
  }

  /// Obtiene la reseña de un usuario para un libro específico.
  ///
  /// Parámetros:
  /// - [uidUser] → ID del usuario.
  /// - [isbn] → ISBN del libro.
  ///
  /// Retorna:
  /// - Objeto `ReviewModel` si existe, de lo contrario `ReviewModel.empty()`.
  Future<ReviewModel> getReviewbyUserAndBook(
      String uidUser,
      String isbn,
      ) async {
    final querySnapshot = await _db
        .collection('reviews')
        .where('idUser', isEqualTo: uidUser)
        .where('idBook', isEqualTo: isbn)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final review = ReviewModel.fromMap(querySnapshot.docs[0].data());
      return review;
    } else {
      return ReviewModel.empty();
    }
  }

  /// Obtiene todas las reseñas hechas por un usuario.
  ///
  /// Parámetros:
  /// - [uidUser] → ID del usuario.
  ///
  /// Retorna:
  /// - Lista de `ReviewModel` creadas por el usuario.
  Future<List<ReviewModel>> getReviewsByUser(String uidUser) async {
    List<ReviewModel> reviews = [];
    final querySnapshot =
    await _db.collection('reviews').where('idUser', isEqualTo: uidUser).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        final review = ReviewModel.fromMap(doc.data());
        reviews.add(review);
      }
    }
    return reviews;
  }

  /// Crea y agrega una nueva reseña a Firestore.
  ///
  /// Parámetros:
  /// - [uidUser] → ID del usuario que hace la reseña.
  /// - [isbn] → ISBN del libro reseñado.
  /// - [commentary] → Comentario de la reseña.
  /// - [start] → Valor de estrellas (1 a 5).
  ///
  /// Retorna:
  /// - El objeto `ReviewModel` recién creado.
  Future<ReviewModel> addReview(
      String uidUser,
      String isbn,
      String commentary,
      int start,
      ) async {
    DateTime now = DateTime.now();
    String date = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    ).toString();

    final collection = _db.collection('reviews');
    final ref = {
      'idUser': uidUser,
      'idBook': isbn,
      'comentary': commentary,
      'stars': start,
      'date': date,
      'idReaction': '', // Campo opcional para futuras reacciones.
    };

    DocumentReference docRef = await collection.add(ref);
    await docRef.update({'idReview': docRef.id});
    return getReview(docRef.id);
  }

  /// Verifica si un usuario ya ha hecho una reseña para un libro.
  ///
  /// Parámetros:
  /// - [uidUser] → ID del usuario.
  /// - [isbn] → ISBN del libro.
  ///
  /// Retorna:
  /// - `true` si existe una reseña, `false` si no.
  Future<bool> hasReview(String uidUser, String isbn) async {
    final querySnapshot = await _db
        .collection('reviews')
        .where('idUser', isEqualTo: uidUser)
        .where('idBook', isEqualTo: isbn)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  /// Edita el comentario y/o puntuación de una reseña existente.
  ///
  /// Parámetros:
  /// - [idReview] → ID de la reseña.
  /// - [commentary] → Nuevo comentario.
  /// - [stars] → Nueva puntuación en estrellas.
  Future<void> editReview(String idReview, String commentary, int stars) async {
    await _db.collection('reviews').doc(idReview).update({
      'comentary': commentary,
      'stars': stars,
    });
  }

  /// Elimina una reseña de la base de datos.
  ///
  /// Parámetros:
  /// - [idReview] → ID de la reseña a eliminar.
  Future<void> deleteReview(String idReview) async {
    await _db.collection('reviews').doc(idReview).delete();
  }

  /// Calcula el promedio de calificaciones de un libro.
  ///
  /// Parámetros:
  /// - [isbn] → ISBN del libro.
  ///
  /// Retorna:
  /// - Promedio de estrellas (`double`). Si no hay reseñas, retorna `0.0`.
  Future<double> calculateAverageRating(String isbn) async {
    double averageRating = 0.0;

    final querySnapshot =
    await _db.collection('reviews').where('idBook', isEqualTo: isbn).get();

    if (querySnapshot.docs.isNotEmpty) {
      double totalRating = 0.0;
      int reviewCount = 0;

      for (var doc in querySnapshot.docs) {
        final review = ReviewModel.fromMap(doc.data());
        totalRating += review.stars;
        reviewCount++;
      }

      if (reviewCount > 0) {
        averageRating = totalRating / reviewCount;
      }
    }
    return averageRating;
  }

  /// Obtiene una lista de ISBNs ordenados por calificación promedio (de mayor a menor).
  ///
  /// Retorna:
  /// - Lista de ISBNs (`List<String>`) ordenados por calificación promedio.
  Future<List<String>> getTopBestIsbnByAverageRating() async {
    final querySnapshot = await _db.collection('reviews').get();

    Map<String, List<int>> ratingsByBooks = {};

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        final review = ReviewModel.fromMap(doc.data());
        ratingsByBooks.putIfAbsent(review.idBook, () => []).add(review.stars);
      }

      List<MapEntry<String, double>> averageRatings =
      ratingsByBooks.entries.map((entry) {
        final ratings = entry.value;
        final averageRating =
            ratings.reduce((a, b) => a + b) / ratings.length;
        return MapEntry(entry.key, averageRating);
      }).toList();

      // Ordenar por calificación descendente
      averageRatings.sort((a, b) => b.value.compareTo(a.value));

      return averageRatings.map((entry) => entry.key).toList();
    } else {
      return [];
    }
  }
}
