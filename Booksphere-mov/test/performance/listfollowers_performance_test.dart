import 'package:booksphere/view/listfollowers_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ListUser performance test - list renders quickly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListUser(uid: 'testUid')));

    final stopwatch = Stopwatch()..start();

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds < 3000, true);
  });
}
