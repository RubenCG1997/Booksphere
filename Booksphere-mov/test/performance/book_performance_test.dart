import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/book_screen.dart';

void main() {
  testWidgets('Book loads within 2 seconds', (WidgetTester tester) async {
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(const MaterialApp(
      home: Book(isbn: 'testISBN', uidUser: 'testUser'),
    ));

    await tester.pumpAndSettle();

    stopwatch.stop();

    // Verificamos que el widget cargue en menos de 2 segundos
    expect(stopwatch.elapsedMilliseconds, lessThan(2000));
  });
}
