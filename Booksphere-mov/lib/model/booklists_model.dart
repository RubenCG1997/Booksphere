/// Modelo que representa una lista de libros asociada a un usuario.
///
/// Contiene un identificador único, el identificador del usuario propietario,
/// el nombre de la lista, una lista de IDs de libros y la fecha de creación.
class BookLists {
  String _id;
  String _idUser;
  String _name;
  List<String> _idBook;
  String _dateCreation;

  /// Constructor vacío que inicializa los campos con valores vacíos o listas vacías.
  BookLists.empty()
      : _id = '',
        _idUser = '',
        _name = '',
        _idBook = [],
        _dateCreation = '';

  /// Constructor que recibe todos los parámetros para inicializar la instancia.
  ///
  /// Parámetros:
  /// - [id]: Identificador único de la lista de libros.
  /// - [idUser]: Identificador del usuario propietario de la lista.
  /// - [name]: Nombre de la lista de libros.
  /// - [idBook]: Lista de identificadores de libros incluidos en la lista.
  /// - [dateCreation]: Fecha en que se creó la lista.
  BookLists(
      this._id,
      this._idUser,
      this._name,
      this._idBook,
      this._dateCreation,
      );

  /// Constructor que crea una instancia a partir de un mapa de datos.
  ///
  /// Parámetros:
  /// - [map]: Mapa con las claves 'id', 'idUser', 'name', 'idBook' y 'dateCreation'.
  ///
  /// Si alguna clave no existe, se asigna un valor vacío o lista vacía por defecto.
  BookLists.fromMap(Map<String, dynamic> map)
      : _id = map['id'] ?? '',
        _idUser = map['idUser'] ?? '',
        _name = map['name'] ?? '',
        _idBook = List<String>.from(map['idBook'] ?? []),
        _dateCreation = map['dateCreation'] ?? '';

  /// Obtiene el identificador único de la lista.
  String get id => _id;

  /// Establece el identificador único de la lista.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador para la lista.
  set id(String value) {
    _id = value;
  }

  /// Obtiene el identificador del usuario propietario de la lista.
  String get idUser => _idUser;

  /// Establece el identificador del usuario propietario de la lista.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador de usuario.
  set idUser(String value) {
    _idUser = value;
  }

  /// Obtiene el nombre de la lista de libros.
  String get name => _name;

  /// Establece el nombre de la lista de libros.
  ///
  /// Parámetros:
  /// - [value]: Nuevo nombre para la lista.
  set name(String value) {
    _name = value;
  }

  /// Obtiene la lista de identificadores de libros.
  List<String> get idBook => _idBook;

  /// Establece la lista de identificadores de libros.
  ///
  /// Parámetros:
  /// - [value]: Nueva lista de IDs de libros.
  set idBook(List<String> value) {
    _idBook = value;
  }

  /// Obtiene la fecha de creación de la lista.
  String get dateCreation => _dateCreation;

  /// Establece la fecha de creación de la lista.
  ///
  /// Parámetros:
  /// - [value]: Nueva fecha de creación.
  set dateCreation(String value) {
    _dateCreation = value;
  }

  /// Convierte la instancia actual a un mapa con las claves correspondientes.
  ///
  /// Retorna un [Map<String, dynamic>] con todos los datos de la lista de libros.
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'idUser': _idUser,
      'name': _name,
      'idBook': _idBook,
      'dateCreation': _dateCreation,
    };
  }
}
