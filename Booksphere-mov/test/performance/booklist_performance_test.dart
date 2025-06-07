import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:booksphere/view/booklist_screen.dart';

void main() {
  testWidgets('Booklist performance test: loads under 2s', (WidgetTester tester) async {
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(
      const MaterialApp(
        home: Booklist(uid: 'testUid', name: 'Lecturas'),
      ),
    );

    await tester.pumpAndSettle();

    stopwatch.stop();

    // Verifica que la carga no tarde más de 2 segundos
    expect(stopwatch.elapsedMilliseconds < 2000, true);
  });
}
