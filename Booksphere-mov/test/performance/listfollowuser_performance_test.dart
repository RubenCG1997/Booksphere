import 'package:booksphere/view/listfollowsuser_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ListFollowUser performance test - rendering list', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListFollowUser(uid: 'testUid')));

    final stopwatch = Stopwatch()..start();

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    stopwatch.stop();

    // Verifica que la lista se renderice en menos de 3 segundos
    expect(stopwatch.elapsedMilliseconds < 3000, true);
  });
}
