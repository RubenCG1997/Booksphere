import 'package:booksphere/view/login_screen.dart';
import 'package:booksphere/view/widgets/button_google.dart';
import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Login widget UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    expect(find.text('Inicia sesión para continuar'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('¿Has olvidado tu contraseña?'), findsOneWidget);
    expect(find.text('¿No tienes cuenta? Registrate aquí'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.byType(SmartButton), findsOneWidget);
    expect(find.byType(ButtonGoogle), findsOneWidget);
  });
}
