import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/book_screen.dart';

void main() {
  testWidgets('Book handles null UID and ISBN gracefully', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Book(isbn: null, uidUser: null),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets('Book handles empty ISBN string safely', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Book(isbn: '', uidUser: 'user123'),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
