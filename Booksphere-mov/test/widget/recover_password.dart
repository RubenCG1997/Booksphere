import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/recover_password_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('RecoverPassword widget test - validations and navigation',
          (WidgetTester tester) async {

        final mockRouter = GoRouter(
          routes: [],
          initialLocation: '/',
        );

        final emailField = find.byType(TextField);
        expect(emailField, findsOneWidget);

        final sendButton = find.widgetWithText(ElevatedButton, 'Enviar');
        expect(sendButton, findsOneWidget);

        await tester.tap(sendButton);
        await tester.pump();

        expect(find.text('Por favor, ingrese un correo electrónico'),
            findsOneWidget);

        await tester.enterText(emailField, 'correo_invalido');
        await tester.tap(sendButton);
        await tester.pump();

        expect(find.text('Por favor, ingrese un correo electrónico válido'),
            findsOneWidget);

        await tester.enterText(emailField, 'test@example.com');

        await tester.tap(sendButton);
        await tester.pump();

        expect(find.text('Correo electrónico enviado'), findsOneWidget);

        final backButton = find.widgetWithText(TextButton, 'Volver atrás');
        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        await tester.pump();


      });
}
