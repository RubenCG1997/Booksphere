import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/reader_screen.dart';

void main() {
  group('Reader security tests', () {
    test('Should reject empty EPUB URL', () {
      expect(
            () => Reader(urlEpub: '', uidUser: 'user123'),
        throwsAssertionError,
      );
    });

    test('Should reject invalid EPUB URL scheme', () {
      final invalidUrl = 'ftp://example.com/book.epub';

      expect(
            () => Reader(urlEpub: invalidUrl, uidUser: 'user123'),
        throwsAssertionError,
      );
    });

    test('Should accept valid HTTPS URL', () {
      final validUrl = 'https://example.com/book.epub';

      expect(
            () => Reader(urlEpub: validUrl, uidUser: 'user123'),
        returnsNormally,
      );
    });

    test('Should reject empty user ID', () {
      final validUrl = 'https://example.com/book.epub';

      expect(
            () => Reader(urlEpub: validUrl, uidUser: ''),
        throwsAssertionError,
      );
    });
  });
}
