import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/recover_password_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('RecoverPassword input validation security test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RecoverPassword()));

    final emailField = find.byType(TextField);
    final sendButton = find.text('Enviar');

   
    await tester.enterText(emailField, '');
    await tester.tap(sendButton);
    await tester.pump();
    expect(find.text('Por favor, ingrese un correo electrónico'), findsOneWidget);


    final maliciousInput = "test@example.com'; DROP TABLE users;--";
    await tester.enterText(emailField, maliciousInput);
    await tester.tap(sendButton);
    await tester.pump();


    expect(find.text('Por favor, ingrese un correo electrónico válido'), findsOneWidget);


    final weirdInput = "<script>alert('XSS')</script>@example.com";
    await tester.enterText(emailField, weirdInput);
    await tester.tap(sendButton);
    await tester.pump();


    expect(find.text('Por favor, ingrese un correo electrónico válido'), findsOneWidget);
  });
}
