import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:booksphere/view/search_screen.dart';

void main() {
  testWidgets('Campo búsqueda no acepta input malicioso ni crash', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Search(uidUser: '123')));

    final maliciousInput = "<script>alert('XSS')</script>";

    await tester.enterText(find.byType(TextField), maliciousInput);
    await tester.pumpAndSettle();

    // Validar que la app sigue funcionando (no crash) y muestra resultados (vacíos o normales)
    expect(find.text('No se encontraron resultados.'), findsOneWidget);
  });

  testWidgets('uidUser requerido para navegación', (tester) async {
    expect(() => Search(uidUser: null), throwsAssertionError);
  });
}
