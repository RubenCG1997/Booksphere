import 'package:booksphere/view/listfollowers_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ListUser UI elements present', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListUser(uid: 'testUid')));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Lista de seguidores'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
