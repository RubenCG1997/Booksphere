/// Modelo que representa un libro con sus propiedades principales.
///
/// Contiene información como ISBN, título, fecha, descripción, autor, editorial,
/// género, y URLs para el archivo EPUB e imagen de portada.
class BookModel {
  String _isbn;
  String _title;
  String _date;
  String _description;
  String _idAuthor;
  String _idPublisher;
  String _genre;
  String _urlEpub;
  String _urlImg;

  /// Constructor vacío que inicializa todos los campos con cadenas vacías.
  BookModel.empty()
      : _isbn = '',
        _title = '',
        _date = '',
        _description = '',
        _idAuthor = '',
        _idPublisher = '',
        _genre = '',
        _urlEpub = '',
        _urlImg = '';

  /// Constructor que inicializa el libro con todos sus campos.
  ///
  /// Parámetros:
  /// - [isbn]: Código ISBN del libro.
  /// - [title]: Título del libro.
  /// - [date]: Fecha de publicación.
  /// - [description]: Descripción del libro.
  /// - [idAuthor]: Identificador del autor.
  /// - [idPublisher]: Identificador de la editorial.
  /// - [genre]: Género literario del libro.
  /// - [urlEpub]: URL del archivo EPUB.
  /// - [urlImg]: URL de la imagen de portada.
  BookModel(
      this._isbn,
      this._title,
      this._date,
      this._description,
      this._idAuthor,
      this._idPublisher,
      this._genre,
      this._urlEpub,
      this._urlImg,
      );

  /// Constructor que crea una instancia de [BookModel] a partir de un mapa.
  ///
  /// Parámetros:
  /// - [map]: Mapa con claves que representan las propiedades del libro:
  ///   'isbn', 'title', 'date', 'description', 'idAuthor', 'idPublisher', 'genre',
  ///   'urlEpub', y 'urlImg'.
  ///
  /// Si alguna clave no existe en el mapa, se asigna una cadena vacía por defecto.
  BookModel.fromMap(Map<String, dynamic> map)
      : _isbn = map['isbn'] ?? '',
        _title = map['title'] ?? '',
        _date = map['date'] ?? '',
        _description = map['description'] ?? '',
        _idAuthor = map['idAuthor'] ?? '',
        _idPublisher = map['idPublisher'] ?? '',
        _genre = map['genre'] ?? '',
        _urlEpub = map['urlEpub'] ?? '',
        _urlImg = map['urlImg'] ?? '';

  /// Género literario del libro.
  String get genre => _genre;
  set genre(String value) {
    _genre = value;
  }

  /// Identificador de la editorial.
  String get idPublisher => _idPublisher;
  set idPublisher(String value) {
    _idPublisher = value;
  }

  /// Identificador del autor.
  String get idAuthor => _idAuthor;
  set idAuthor(String value) {
    _idAuthor = value;
  }

  /// Descripción del libro.
  String get description => _description;
  set description(String value) {
    _description = value;
  }

  /// Fecha de publicación.
  String get date => _date;
  set date(String value) {
    _date = value;
  }

  /// Título del libro.
  String get title => _title;
  set title(String value) {
    _title = value;
  }

  /// Código ISBN del libro.
  String get isbn => _isbn;
  set isbn(String value) {
    _isbn = value;
  }

  /// URL del archivo EPUB.
  String get urlEpub => _urlEpub;
  set urlEpub(String value) {
    _urlEpub = value;
  }

  /// URL de la imagen de portada.
  String get urlImg => _urlImg;
  set urlImg(String value) {
    _urlImg = value;
  }

  /// Convierte la instancia de libro a un mapa para almacenamiento o envío.
  ///
  /// Retorna un [Map<String, dynamic>] con las propiedades del libro:
  /// 'isbn', 'title', 'date', 'description', 'idAuthor', 'idPublisher', 'genre',
  /// 'urlEpub', y 'urlImg'.
  Map<String, dynamic> toMap() {
    return {
      'isbn': _isbn,
      'title': _title,
      'date': _date,
      'description': _description,
      'idAuthor': _idAuthor,
      'idPublisher': _idPublisher,
      'genre': _genre,
      'urlEpub': _urlEpub,
      'urlImg': _urlImg,
    };
  }
}
