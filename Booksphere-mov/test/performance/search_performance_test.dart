import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:booksphere/view/search_screen.dart';

void main() {
  testWidgets('Performance test carga y búsqueda', (tester) async {
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(MaterialApp(home: Search(uidUser: '123')));
    await tester.pumpAndSettle();

    stopwatch.stop();
    print('Tiempo para cargar Search: ${stopwatch.elapsedMilliseconds} ms');
    expect(stopwatch.elapsedMilliseconds < 2000, isTrue); 

    // Medir búsqueda
    stopwatch.reset();
    stopwatch.start();

    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pumpAndSettle();

    stopwatch.stop();
    print('Tiempo para filtrar libros: ${stopwatch.elapsedMilliseconds} ms');
    expect(stopwatch.elapsedMilliseconds < 1000, isTrue);
  });
}
