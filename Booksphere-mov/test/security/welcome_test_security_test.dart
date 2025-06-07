import 'package:booksphere/view/welcome_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pruebas básicas de seguridad - Welcome', () {
    testWidgets('No se exponen datos sensibles', (tester) async {
      await tester.pumpWidget(const Welcome());

      expect(find.textContaining('password'), findsNothing);
      expect(find.textContaining('token'), findsNothing);
    });
  });
}
