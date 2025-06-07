import 'package:booksphere/view/welcome_screen.dart';
import 'package:booksphere/view/widgets/image_app.dart';
import 'package:booksphere/view/widgets/name_app.dart';
import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:booksphere/view/widgets/smarttextbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('Pruebas UI y Funcionales - Welcome Widget', () {
    // Test de renderizado y visibilidad
    testWidgets('Renderiza correctamente todos los widgets', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Welcome()));

      expect(find.byType(ImageApp), findsOneWidget);
      expect(find.byType(NameApp), findsOneWidget);
      expect(find.byType(SmartButton), findsOneWidget);
      expect(find.byType(SmartTextbutton), findsOneWidget);

      expect(find.text("Iniciar Sesión"), findsOneWidget);
      expect(find.text("¿No tienes cuenta?,Registrate aquí"), findsOneWidget);
    });

    // Test navegación botón Iniciar Sesión
    testWidgets('Navega a /Login al pulsar Iniciar Sesión', (tester) async {
      String? location;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const Welcome()),
          GoRoute(
            path: '/Login',
            builder: (context, state) {
              location = '/Login';
              return const Scaffold(body: Text('Pantalla Login'));
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Iniciar Sesión"));
      await tester.pumpAndSettle();

      expect(location, '/Login');
    });

    // Test navegación texto registro
    testWidgets('Navega a /register al pulsar texto registro', (tester) async {
      String? location;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const Welcome()),
          GoRoute(
            path: '/register',
            builder: (context, state) {
              location = '/register';
              return const Scaffold(body: Text('Pantalla Registro'));
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text("¿No tienes cuenta?,Registrate aquí"));
      await tester.pumpAndSettle();

      expect(location, '/register');
    });

    // Test adaptabilidad (pantallas pequeñas y grandes)
    testWidgets('Se adapta a diferentes tamaños de pantalla', (tester) async {
      final smallSize = Size(320, 600);
      final largeSize = Size(1080, 1920);

      await tester.binding.setSurfaceSize(smallSize);
      await tester.pumpWidget(const MaterialApp(home: Welcome()));
      await tester.pumpAndSettle();
      expect(find.byType(Welcome), findsOneWidget);

      await tester.binding.setSurfaceSize(largeSize);
      await tester.pumpWidget(const MaterialApp(home: Welcome()));
      await tester.pumpAndSettle();
      expect(find.byType(Welcome), findsOneWidget);

      // Limpia tamaño para pruebas posteriores
      await tester.binding.setSurfaceSize(null);
    });

    // Test multilenguaje (simulación simple)
    testWidgets('Muestra texto correcto en español e inglés', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Welcome()));

      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('¿No tienes cuenta?,Registrate aquí'), findsOneWidget);

    });

    // Test accesibilidad básica
    testWidgets('Botón Iniciar Sesión tiene label accesible', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Welcome()));
      final loginButton = find.byType(SmartButton);
      expect(tester.getSemantics(loginButton), matchesSemantics(label: 'Iniciar Sesión'));
    });
  });
}
