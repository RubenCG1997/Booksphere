import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RecoverPassword performance test', (WidgetTester tester) async {
    // Medir tiempo de arranque y renderizado inicial
    final stopwatch = Stopwatch()..start();

    app.main();
    await tester.pumpAndSettle();

    stopwatch.stop();
    print('Tiempo de arranque y renderizado: ${stopwatch.elapsedMilliseconds} ms');
    
    final emailField = find.byType(TextField);
    expect(emailField, findsOneWidget);

    final textEntryStopwatch = Stopwatch()..start();

    await tester.enterText(emailField, 'test@example.com');
    await tester.pump();

    textEntryStopwatch.stop();
    print('Tiempo para ingresar texto en campo email: ${textEntryStopwatch.elapsedMilliseconds} ms');

    final sendButton = find.text('Enviar');
    expect(sendButton, findsOneWidget);

    final tapStopwatch = Stopwatch()..start();

    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    tapStopwatch.stop();
    print('Tiempo para presionar botón enviar y responder: ${tapStopwatch.elapsedMilliseconds} ms');

  });
}
