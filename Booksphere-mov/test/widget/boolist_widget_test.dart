import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/booklist_screen.dart';

void main() {
  testWidgets('Booklist UI contains FloatingActionButton and ListView', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Booklist(uid: 'user123', name: 'Sci-Fi'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);

    expect(find.byIcon(Icons.add), findsOneWidget);

    expect(find.byType(ListView), findsOneWidget);
  });
}
