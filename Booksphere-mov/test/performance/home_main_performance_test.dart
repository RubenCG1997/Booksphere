import 'package:booksphere/view/homeMain_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Home performance test - tab switching', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home(uid: 'testUid')));

    final stopwatch = Stopwatch()..start();

    await tester.tap(find.text('Mis listas'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds < 2000, true);
  });
}
