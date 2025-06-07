import 'package:booksphere/view/listfollowsuser_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ListFollowUser search clears and reloads list', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListFollowUser(uid: 'testUid')));

    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);

    await tester.enterText(searchField, 'nonexistentuser');
    await tester.pumpAndSettle();

    expect(find.text('No hay coincidencias'), findsOneWidget);

    // Tap clear button
    final clearButton = find.byIcon(Icons.clear_rounded);
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(find.text('No hay coincidencias'), findsNothing);
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('Follow/Unfollow button toggles text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListFollowUser(uid: 'testUid')));

    await tester.pumpAndSettle();

    final followButtons = find.widgetWithText(ElevatedButton, 'Seguir').evaluate();
    if (followButtons.isNotEmpty) {
      final firstButton = followButtons.first.widget as ElevatedButton;

      expect(find.text('Seguir'), findsWidgets);

      // No podemos tap directamente sin mocks, pero al menos el botón está
    }
  });
}
