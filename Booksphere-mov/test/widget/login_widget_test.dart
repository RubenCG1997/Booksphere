import 'package:booksphere/view/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Login widget performance test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    final stopwatch = Stopwatch()..start();

    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.text('Iniciar Sesión'));
    await tester.pumpAndSettle();

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds < 2000, true);
  });
}
