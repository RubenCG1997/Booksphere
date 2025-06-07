
import 'package:booksphere/view/listfollowsuser_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('ListFollowUser integration test - navigation and data load', (WidgetTester tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ListFollowUser(uid: 'testUid'),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  });
}
