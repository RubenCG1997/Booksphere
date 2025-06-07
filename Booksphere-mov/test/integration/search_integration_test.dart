import 'package:booksphere/view/search_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:booksphere/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Flujo completo de búsqueda y navegación', (tester) async {
    app.main();
    await tester.pumpAndSettle();


    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();


    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.pumpAndSettle();

    expect(find.text('Coincidencias'), findsOneWidget);


    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();


    expect(find.textContaining('flutter', findRichText: true), findsWidgets);


    await tester.pageBack();
    await tester.pumpAndSettle();

   
    expect(find.byType(Search), findsOneWidget);
  });
}
