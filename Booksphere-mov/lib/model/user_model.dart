/// Modelo que representa un usuario con información personal,
/// libros leídos, relaciones sociales y tipo de suscripción.
///
/// Proporciona varios constructores para diferentes formas de
/// creación, así como getters y setters para acceder y modificar sus propiedades.
class UserModel {
  String _uid;
  String _email;
  String _username;
  Map<String, String> _readerBooks;
  List<String> _follows;
  List<String> _followers;
  String _subscription;

  /// Constructor vacío que inicializa todos los campos con valores vacíos o por defecto.
  UserModel.empty()
      : _uid = '',
        _email = '',
        _username = '',
        _readerBooks = {},
        _follows = [],
        _followers = [],
        _subscription = '';

  /// Constructor que recibe todos los parámetros para inicializar el usuario.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del usuario.
  /// - [email]: Correo electrónico del usuario.
  /// - [username]: Nombre de usuario.
  /// - [readerBooks]: Mapa con libros leídos, donde la clave es el ID del libro y el valor puede ser alguna información adicional.
  /// - [follows]: Lista de IDs de usuarios a los que este usuario sigue.
  /// - [followers]: Lista de IDs de usuarios que siguen a este usuario.
  /// - [subscription]: Tipo o estado de suscripción del usuario.
  UserModel(
      this._uid,
      this._email,
      this._username,
      this._readerBooks,
      this._follows,
      this._followers,
      this._subscription,
      );

  /// Constructor para crear un usuario nuevo con email.
  ///
  /// Inicializa [readerBooks], [follows] y [followers] como vacíos.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del usuario.
  /// - [email]: Correo electrónico del usuario.
  /// - [username]: Nombre de usuario.
  /// - [subscription]: Tipo o estado de suscripción del usuario.
  UserModel.createUser(
      this._uid,
      this._email,
      this._username,
      this._subscription,
      )   : _readerBooks = {},
        _follows = [],
        _followers = [];

  /// Constructor para crear un usuario nuevo con autenticación de Google.
  ///
  /// Inicializa [readerBooks], [follows] y [followers] como vacíos.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del usuario.
  /// - [email]: Correo electrónico del usuario.
  /// - [username]: Nombre de usuario.
  /// - [subscription]: Tipo o estado de suscripción del usuario.
  UserModel.createWithGoogle(
      this._uid,
      this._email,
      this._username,
      this._subscription,
      )   : _readerBooks = {},
        _follows = [],
        _followers = [];

  /// Constructor que crea una instancia de [UserModel] a partir de un mapa de datos.
  ///
  /// Parámetros:
  /// - [map]: Mapa con las claves y valores correspondientes a las propiedades del usuario.
  ///   Las claves esperadas son: 'uid', 'email', 'username', 'readerBooks',
  ///   'follows', 'followers' y 'subscription'.
  UserModel.fromMap(Map<String, dynamic> map)
      : _uid = map['uid'] ?? '',
        _email = map['email'] ?? '',
        _username = map['username'] ?? '',
        _readerBooks = Map<String, String>.from(map['readerBooks'] ?? {}),
        _follows = List<String>.from(map['follows'] ?? []),
        _followers = List<String>.from(map['followers'] ?? []),
        _subscription = map['subscription'] ?? '';

  // Getters y Setters para todas las propiedades.

  /// Obtiene el tipo o estado de suscripción del usuario.
  String get subscription => _subscription;

  /// Establece el tipo o estado de suscripción del usuario.
  set subscription(String value) {
    _subscription = value;
  }

  /// Obtiene la lista de IDs de usuarios que siguen a este usuario.
  List<String> get followers => _followers;

  /// Establece la lista de IDs de usuarios que siguen a este usuario.
  set followers(List<String> value) {
    _followers = value;
  }

  /// Obtiene la lista de IDs de usuarios a los que este usuario sigue.
  List<String> get follows => _follows;

  /// Establece la lista de IDs de usuarios a los que este usuario sigue.
  set follows(List<String> value) {
    _follows = value;
  }

  /// Obtiene el mapa de libros leídos por el usuario.
  Map<String, String> get readerBooks => _readerBooks;

  /// Establece el mapa de libros leídos por el usuario.
  set readerBooks(Map<String, String> value) {
    _readerBooks = value;
  }

  /// Obtiene el nombre de usuario.
  String get username => _username;

  /// Establece el nombre de usuario.
  set username(String value) {
    _username = value;
  }

  /// Obtiene el correo electrónico del usuario.
  String get email => _email;

  /// Establece el correo electrónico del usuario.
  set email(String value) {
    _email = value;
  }

  /// Obtiene el identificador único del usuario.
  String get uid => _uid;

  /// Establece el identificador único del usuario.
  set uid(String value) {
    _uid = value;
  }

  /// Convierte la instancia actual a un mapa con todas sus propiedades.
  ///
  /// Útil para almacenar en bases de datos o enviar a través de la red.
  Map<String, dynamic> toMap() {
    return {
      'uid': _uid,
      'email': _email,
      'username': _username,
      'readerBooks': _readerBooks,
      'follows': _follows,
      'followers': _followers,
      'subscription': _subscription,
    };
  }
}
