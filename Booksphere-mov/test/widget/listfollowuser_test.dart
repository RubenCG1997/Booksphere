import 'package:booksphere/view/listfollowsuser_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ListFollowUser UI elements test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListFollowUser(uid: 'testUid')));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Lista de seguidos'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
