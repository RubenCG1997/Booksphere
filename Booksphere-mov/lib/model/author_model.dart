/// Modelo que representa un autor con un identificador único y nombre.
///
/// Proporciona constructores para crear instancias vacías, desde parámetros
/// o desde un mapa, además de getters y setters para sus propiedades.
class AuthorModel {
  String _uid;
  String _name;

  /// Constructor vacío que inicializa los campos con valores vacíos.
  AuthorModel.empty() : _uid = '', _name = '';

  /// Constructor que recibe el identificador único [uid] y el [name] del autor.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del autor.
  /// - [name]: Nombre del autor.
  AuthorModel(this._uid, this._name);

  /// Constructor que crea una instancia a partir de un mapa de datos.
  ///
  /// Parámetros:
  /// - [map]: Mapa con las claves 'uid' y 'name' que contienen la información del autor.
  ///
  /// Si alguna clave no existe, se asigna una cadena vacía por defecto.
  AuthorModel.fromMap(Map<String, dynamic> map)
      : _uid = map['uid'] ?? '',
        _name = map['name'] ?? '';

  /// Obtiene el nombre del autor.
  String get name => _name;

  /// Establece el nombre del autor.
  ///
  /// Parámetros:
  /// - [value]: Nuevo nombre para el autor.
  set name(String value) {
    _name = value;
  }

  /// Obtiene el UID (identificador único) del autor.
  String get uid => _uid;

  /// Establece el UID (identificador único) del autor.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador único para el autor.
  set uid(String value) {
    _uid = value;
  }

  /// Convierte la instancia actual a un mapa con claves 'uid' y 'name'.
  ///
  /// Retorna un [Map<String, dynamic>] con los datos del autor, útil para
  /// almacenamiento o envío por red.
  Map<String, dynamic> toMap() {
    return {'uid': _uid, 'name': _name};
  }
}
