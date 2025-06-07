import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:booksphere/view/booklist_screen.dart';

void main() {
  testWidgets('Booklist handles empty UID gracefully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Booklist(uid: '', name: 'Libros'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);

    expect(find.text('Libros'), findsOneWidget);
  });
}
