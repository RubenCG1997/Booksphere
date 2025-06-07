/// Modelo que representa una reseña de un libro realizada por un usuario.
///
/// Contiene información como el identificador de la reseña, usuario, libro,
/// comentario, fecha, puntuación en estrellas y la reacción asociada.
///
/// Proporciona constructores para crear instancias vacías, desde parámetros
/// o desde un mapa, además de getters y setters para sus propiedades.
class ReviewModel {
  String _idReview;
  String _idUser;
  String _idBook;
  String _comentary;
  String _date;
  int _stars;
  String _idReaction;

  /// Constructor vacío que inicializa los campos con valores predeterminados.
  ReviewModel.empty()
      : _idReview = '',
        _idUser = '',
        _idBook = '',
        _comentary = '',
        _date = '',
        _stars = 0,
        _idReaction = '';

  /// Constructor que recibe los valores para todos los campos de la reseña.
  ///
  /// Parámetros:
  /// - [idReview]: Identificador único de la reseña.
  /// - [idUser]: Identificador del usuario que hizo la reseña.
  /// - [idBook]: Identificador del libro reseñado.
  /// - [comentary]: Texto del comentario de la reseña.
  /// - [date]: Fecha en que se realizó la reseña.
  /// - [stars]: Número de estrellas otorgadas (puntuación).
  /// - [idReaction]: Identificador de la reacción asociada a la reseña.
  ReviewModel(
      this._idReview,
      this._idUser,
      this._idBook,
      this._comentary,
      this._date,
      this._stars,
      this._idReaction,
      );

  /// Constructor que crea una instancia a partir de un mapa de datos.
  ///
  /// Parámetros:
  /// - [map]: Mapa con las claves 'idReview', 'idUser', 'idBook', 'comentary',
  ///   'date', 'stars' y 'idReaction'.
  ///
  /// Si alguna clave no existe, se asigna un valor predeterminado (cadena vacía o 0).
  ReviewModel.fromMap(Map<String, dynamic> map)
      : _idReview = map['idReview'] ?? '',
        _idUser = map['idUser'] ?? '',
        _idBook = map['idBook'] ?? '',
        _comentary = map['comentary'] ?? '',
        _date = map['date'] ?? '',
        _stars = map['stars'] ?? 0,
        _idReaction = map['idReaction'] ?? '';

  /// Obtiene el identificador único de la reseña.
  String get idReview => _idReview;

  /// Establece el identificador único de la reseña.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador para la reseña.
  set idReview(String value) {
    _idReview = value;
  }

  /// Convierte la instancia actual a un mapa con las claves correspondientes.
  ///
  /// Útil para guardar en bases de datos o enviar por red.
  Map<String, dynamic> toMap() {
    return {
      'idReview': _idReview,
      'idUser': _idUser,
      'idBook': _idBook,
      'comentary': _comentary,
      'date': _date,
      'stars': _stars,
      'idReaction': _idReaction,
    };
  }

  /// Obtiene el identificador del usuario que realizó la reseña.
  String get idUser => _idUser;

  /// Establece el identificador del usuario que realizó la reseña.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador de usuario.
  set idUser(String value) {
    _idUser = value;
  }

  /// Obtiene el identificador del libro reseñado.
  String get idBook => _idBook;

  /// Establece el identificador del libro reseñado.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador del libro.
  set idBook(String value) {
    _idBook = value;
  }

  /// Obtiene el comentario de la reseña.
  String get comentary => _comentary;

  /// Establece el comentario de la reseña.
  ///
  /// Parámetros:
  /// - [value]: Nuevo texto del comentario.
  set comentary(String value) {
    _comentary = value;
  }

  /// Obtiene la fecha en que se realizó la reseña.
  String get date => _date;

  /// Establece la fecha en que se realizó la reseña.
  ///
  /// Parámetros:
  /// - [value]: Nueva fecha en formato cadena.
  set date(String value) {
    _date = value;
  }

  /// Obtiene la cantidad de estrellas otorgadas en la reseña.
  int get stars => _stars;

  /// Establece la cantidad de estrellas otorgadas en la reseña.
  ///
  /// Parámetros:
  /// - [value]: Nuevo número de estrellas.
  set stars(int value) {
    _stars = value;
  }

  /// Obtiene el identificador de la reacción asociada a la reseña.
  String get idReaction => _idReaction;

  /// Establece el identificador de la reacción asociada a la reseña.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador de reacción.
  set idReaction(String value) {
    _idReaction = value;
  }
}
