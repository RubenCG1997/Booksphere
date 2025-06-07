import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/reader_screen.dart';

void main() {
  testWidgets('Reader performance test - load and render', (WidgetTester tester) async {
    const testUrl = 'https://example.com/book.epub';
    const testUid = 'user123';

    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(
      MaterialApp(
        home: Reader(urlEpub: testUrl, uidUser: testUid),
      ),
    );
    
    await tester.pumpAndSettle(const Duration(seconds: 10));

    stopwatch.stop();

    print('Tiempo para cargar y renderizar Reader: ${stopwatch.elapsedMilliseconds} ms');

    expect(stopwatch.elapsedMilliseconds, lessThan(5000), reason: 'Carga demasiado lenta');

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
