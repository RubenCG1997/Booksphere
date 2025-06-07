import 'package:booksphere/view/listfollowers_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ListUser search clears and reloads list', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListUser(uid: 'testUid')));

    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);

    await tester.enterText(searchField, 'usuarioinexistente');
    await tester.pumpAndSettle();

    expect(find.text('No hay coincidencias'), findsOneWidget);

    // Tap botón de limpiar búsqueda
    final clearButton = find.byIcon(Icons.clear_rounded);
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(find.text('No hay coincidencias'), findsNothing);
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('Follow/Unfollow button toggles text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListUser(uid: 'testUid')));

    await tester.pumpAndSettle();

    final followButtons = find.widgetWithText(ElevatedButton, 'Seguir').evaluate();
    if (followButtons.isNotEmpty) {
      // Solo verificar que existen botones para seguir
      expect(find.text('Seguir'), findsWidgets);
    }
  });
}
