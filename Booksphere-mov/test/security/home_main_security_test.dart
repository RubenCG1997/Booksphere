import 'package:booksphere/view/homeMain_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Home handles null UID gracefully', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home(uid: null)));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
  });
}
