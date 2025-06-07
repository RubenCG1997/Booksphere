import 'package:booksphere/view/homeMain_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Home UI contains BottomNavigationBar and pages', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home(uid: 'testUid')));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
