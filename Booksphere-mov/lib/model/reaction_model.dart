/// Modelo que representa una reacción realizada por un usuario, con un identificador,
/// un ícono asociado y el identificador del usuario que hizo la reacción.
///
/// Proporciona constructores para crear instancias vacías, desde parámetros
/// o desde un mapa, además de getters y setters para sus propiedades.
class ReactionModel {
  String _idReaction;
  String _icon;
  String _idUser;

  /// Constructor vacío que inicializa los campos con valores vacíos.
  ReactionModel.empty() : _idReaction = '', _icon = '', _idUser = '';

  /// Constructor que recibe los valores de la reacción.
  ///
  /// Parámetros:
  /// - [idReaction]: Identificador único de la reacción.
  /// - [icon]: Icono o representación visual de la reacción.
  /// - [idUser]: Identificador del usuario que realizó la reacción.
  ReactionModel(this._idReaction, this._icon, this._idUser);

  /// Constructor que crea una instancia a partir de un mapa de datos.
  ///
  /// Parámetros:
  /// - [map]: Mapa con las claves 'idReaction', 'icon' y 'idUser'.
  ///
  /// Si alguna clave no existe, se asigna un valor por defecto (cadena vacía).
  ReactionModel.fromMap(Map<String, dynamic> map)
      : _idReaction = map['idReaction'] ?? '',
        _icon = map['icon'] ?? '',
        _idUser = map['idUser'] ?? '';

  /// Obtiene el identificador único de la reacción.
  String get idReaction => _idReaction;

  /// Establece el identificador único de la reacción.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador para la reacción.
  set idReaction(String value) {
    _idReaction = value;
  }

  /// Obtiene el icono de la reacción.
  String get icon => _icon;

  /// Establece el icono de la reacción.
  ///
  /// Parámetros:
  /// - [value]: Nuevo icono para la reacción.
  set icon(String value) {
    _icon = value;
  }

  /// Obtiene el identificador del usuario que hizo la reacción.
  String get idUser => _idUser;

  /// Establece el identificador del usuario que hizo la reacción.
  ///
  /// Parámetros:
  /// - [value]: Nuevo identificador de usuario.
  set idUser(String value) {
    _idUser = value;
  }

  /// Convierte la instancia actual a un mapa con claves 'idReaction', 'icon' y 'idUser'.
  ///
  /// Útil para guardar en bases de datos o enviar por red.
  Map<String, dynamic> toMap() {
    return {'idReaction': _idReaction, 'icon': _icon, 'idUser': _idUser};
  }
}
