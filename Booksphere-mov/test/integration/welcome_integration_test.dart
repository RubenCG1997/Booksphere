import 'package:booksphere/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Flujo completo Welcome -> Login y Welcome -> Registro', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Pantalla Login'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('¿No tienes cuenta?,Registrate aquí'));
    await tester.pumpAndSettle();
    expect(find.text('Pantalla Registro'), findsOneWidget);
  });
}

class IntegrationTestWidgetsFlutterBinding {
  static void ensureInitialized() {}
}
