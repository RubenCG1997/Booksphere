/// Modelo que representa un editor con un identificador único y nombre.
///
/// Proporciona constructores para crear instancias vacías, desde parámetros
/// o desde un mapa, además de getters y setters para sus propiedades.
class PublisherModel {
  String _uid;
  String _name;

  /// Constructor vacío que inicializa los campos con valores vacíos.
  PublisherModel.empty() : _uid = '', _name = '';

  /// Constructor que recibe el [uid] y [name] del editor.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del editor.
  /// - [name]: Nombre del editor.
  PublisherModel(this._uid, this._name);

  /// Constructor que crea una instancia a partir de un mapa de datos.
  ///
  /// Parámetros:
  /// - [map]: Mapa con las claves 'uid' y 'name'.
  ///
  /// Si alguna clave no existe, se asigna una cadena vacía por defecto.
  PublisherModel.fromMap(Map<String, dynamic> map)
      : _uid = map['uid'] ?? '',
        _name = map['name'] ?? '';

  /// Obtiene el nombre del editor.
  String get name => _name;

  /// Establece el nombre del editor.
  ///
  /// Parámetros:
  /// - [value]: Nuevo nombre para el editor.
  set name(String value) {
    _name = value;
  }

  /// Obtiene el UID (identificador único) del editor.
  String get uid => _uid;

  /// Establece el UID (identificador único) del editor.
  ///
  /// Parámetros:
  /// - [value]: Nuevo UID para el editor.
  set uid(String value) {
    _uid = value;
  }

  /// Convierte la instancia actual a un mapa con claves 'uid' y 'name'.
  ///
  /// Útil para guardar en bases de datos o enviar por red.
  Map<String, dynamic> toMap() {
    return {'uid': _uid, 'name': _name};
  }
}
