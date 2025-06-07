import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:booksphere/view/booklist_screen.dart';

void main() {
  testWidgets('Booklist loads and displays books', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Booklist(uid: 'testUid', name: 'Favoritos'),
      ),
    );

    // Espera la carga inicial
    await tester.pumpAndSettle();

    // Verifica presencia del AppBar y título
    expect(find.text('Favoritos'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Edit mode shows text field', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Booklist(uid: 'testUid', name: 'Lecturas'),
      ),
    );

    await tester.pumpAndSettle();

    // Entra en modo edición
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();

    expect(find.text('Editar lista'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
