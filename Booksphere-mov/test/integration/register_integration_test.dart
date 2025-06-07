import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/main.dart' as app; // Asumiendo que main.dart inicia la app
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full registration flow integration test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final usernameField = find.byType(TextField).at(0);
    final emailField = find.byType(TextField).at(1);
    final passwordField = find.byType(TextField).at(2);

    await tester.enterText(usernameField, 'testuser');
    await tester.enterText(emailField, 'testuser@example.com');
    await tester.enterText(passwordField, 'password123');

    final elegirPlanButton = find.text('Elegir Plan');
    expect(elegirPlanButton, findsOneWidget);
    await tester.tap(elegirPlanButton);
    await tester.pumpAndSettle();

    final planGratuitoButton = find.text('Plan Gratuito');
    await tester.tap(planGratuitoButton);
    await tester.pumpAndSettle();

    final aceptarButton = find.text('Aceptar');
    await tester.tap(aceptarButton);

    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
