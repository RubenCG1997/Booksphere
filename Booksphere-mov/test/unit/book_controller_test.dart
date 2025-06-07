import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/controller/book_controller.dart';
import 'package:booksphere/model/book_model.dart';

void main() {
  late BookController controller;

  setUp(() {
    controller = BookController();
  });

  test('getBook returns a BookModel or null', () async {
    final book = await controller.getBook('some_valid_isbn_or_invalid');
    expect(book == null || book is BookModel, true);
  });

  test('getBooksGenre returns a List<BookModel>', () async {
    final books = await controller.getBooksGenre('some_genre');
    expect(books, isA<List<BookModel>>());
  });

  test('getBooks returns a List<BookModel>', () async {
    final books = await controller.getBooks();
    expect(books, isA<List<BookModel>>());
  });

  test('getBooksByTitle returns a List<BookModel>', () async {
    final books = await controller.getBooksByTitle('some_title');
    expect(books, isA<List<BookModel>>());
  });

  test('getBookbyUrl returns a BookModel or null', () async {
    final book = await controller.getBookbyUrl('some_url_epub');
    expect(book == null || book is BookModel, true);
  });
}
