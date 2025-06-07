import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/book_screen.dart';

void main() {
  group('Widget Tests - Book', () {
    testWidgets('Book widget renders key UI components', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Book(isbn: 'testISBN', uidUser: 'testUser'),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Leer libro'), findsOneWidget);
      expect(find.text('Reseñas'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Book), findsOneWidget);
    });

    testWidgets('Book screen displays fallback when no reviews exist', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Book(isbn: 'no_reviews_isbn', uidUser: 'user_001'),
      ));

      await tester.pumpAndSettle();

      expect(find.text('No hay reseñas aún.'), findsOneWidget);
    });
  });
}
