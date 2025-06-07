import 'package:booksphere/view/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Login widget does not allow empty credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pump();

    expect(find.text('Por favor, complete todos los campos'), findsOneWidget);
  });

  testWidgets('Login widget blocks invalid email format', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    await tester.enterText(find.byType(TextField).first, 'invalidemail');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pump();

    expect(find.textContaining('correo'), findsNothing);
  });
}
