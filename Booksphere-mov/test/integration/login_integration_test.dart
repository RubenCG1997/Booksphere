import 'package:booksphere/view/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Login integration test - flow and navigation', (WidgetTester tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Login()),
        GoRoute(path: '/recover_password', builder: (context, state) => Scaffold(body: Text('Recover Password'))),
        GoRoute(path: '/register', builder: (context, state) => Scaffold(body: Text('Register'))),
        GoRoute(path: '/home', builder: (context, state) => Scaffold(body: Text('Home'))),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('Inicia sesión para continuar'), findsOneWidget);

    await tester.tap(find.text('¿Has olvidado tu contraseña?'));
    await tester.pumpAndSettle();
    expect(find.text('Recover Password'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('¿No tienes cuenta? Registrate aquí'));
    await tester.pumpAndSettle();
    expect(find.text('Register'), findsOneWidget);
  });
}
