import 'package:booksphere/view/homeMain_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Home integration test - tab navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home(uid: 'testUid')));

    // Al iniciar, debería mostrar la pestaña Inicio (HomeTab)
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);

    // Tap en "Mis listas"
    await tester.tap(find.text('Mis listas'));
    await tester.pumpAndSettle();

    // Tap en "Perfil"
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    // Tap de vuelta a "Inicio"
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
  });
}
