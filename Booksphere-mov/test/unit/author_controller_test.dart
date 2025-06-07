import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/controller/author_controller.dart';

void main() {
  late AuthorController controller;

  setUp(() {
    // Aquí inicializas el controlador antes de cada test
    controller = AuthorController();
  });

  test('getNameAuthor returns null for non-existing UID', () async {
    // Como no hay conexión, debe manejar la excepción y devolver null
    final result = await controller.getNameAuthor('nonExistingUID');
    expect(result, null);
  });

}
