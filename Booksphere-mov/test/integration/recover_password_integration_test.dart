import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RecoverPassword integration test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final emailField = find.byType(TextField);
    expect(emailField, findsOneWidget);

    final sendButton = find.text('Enviar');
    expect(sendButton, findsOneWidget);

    // 1. Enviar con campo vacío
    await tester.tap(sendButton);
    await tester.pump();

    expect(find.text('Por favor, ingrese un correo electrónico'), findsOneWidget);

    // 2. Ingresar email inválido
    await tester.enterText(emailField, 'email_invalido');
    await tester.tap(sendButton);
    await tester.pump();

    expect(find.text('Por favor, ingrese un correo electrónico válido'), findsOneWidget);

    // 3. Ingresar email válido
    await tester.enterText(emailField, 'test@example.com');
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    // Verificar SnackBar éxito
    expect(find.text('Correo electrónico enviado'), findsOneWidget);

    // Verificar navegación a login (depende del texto que se muestre o widget en login)
    expect(find.text('Login'), findsOneWidget);
  });
}
