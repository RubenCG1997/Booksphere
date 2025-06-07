import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:booksphere/view/search_screen.dart';

void main() {
  testWidgets('Muestra recomendaciones al iniciar y cambia texto al buscar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Search(uidUser: '123')));

    // Espera que muestre "Recomendaciones"
    expect(find.text('Recomendaciones'), findsOneWidget);

    // Escribir texto en el campo de búsqueda
    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pumpAndSettle();

    // Ahora debería mostrar "Coincidencias"
    expect(find.text('Coincidencias'), findsOneWidget);
  });
}
