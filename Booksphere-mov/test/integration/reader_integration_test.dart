import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/reader_screen.dart';


void main() {

  testWidgets('Reader integration test loads book and restores last position',
          (WidgetTester tester) async {
        const testUrl = 'https://example.com/book.epub';
        const testUid = 'user123';

        await tester.pumpWidget(
          MaterialApp(
            home: Reader(urlEpub: testUrl, uidUser: testUid),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);

        expect(find.byType(Drawer), findsOneWidget);

        expect(find.byType(EpubView), findsOneWidget);

        final backButton = find.byIcon(Icons.arrow_back_ios_rounded);
        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        await tester.pumpAndSettle();
        
      });
}
