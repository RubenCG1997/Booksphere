import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  group('StepperRegister widget tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = MaterialApp(
        home: Scaffold(
          body: StepperRegister(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            usernameController: TextEditingController(),
          ),
        ),
      );
    });

    testWidgets('Shows error if fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);

      final elegirPlanButton = find.text('Elegir Plan');
      expect(elegirPlanButton, findsOneWidget);

      await tester.tap(elegirPlanButton);
      await tester.pump();

      expect(find.text('Debes llenar todos los campos'), findsOneWidget);
    });

    testWidgets('Shows error if fields are invalid', (WidgetTester tester) async {
      final usernameController = TextEditingController(text: 'ab');
      final emailController = TextEditingController(text: 'invalidemail');
      final passwordController = TextEditingController(text: '123');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StepperRegister(
            emailController: emailController,
            passwordController: passwordController,
            usernameController: usernameController,
          ),
        ),
      ));

      final elegirPlanButton = find.text('Elegir Plan');
      expect(elegirPlanButton, findsOneWidget);

      await tester.tap(elegirPlanButton);
      await tester.pump();


      expect(find.text('Revisa los campos para poder continuar'), findsOneWidget);
    });

    testWidgets('Step advances when valid inputs are given', (WidgetTester tester) async {
      final usernameController = TextEditingController(text: 'username');
      final emailController = TextEditingController(text: 'test@example.com');
      final passwordController = TextEditingController(text: '123456');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StepperRegister(
            emailController: emailController,
            passwordController: passwordController,
            usernameController: usernameController,
          ),
        ),
      ));

      final elegirPlanButton = find.text('Elegir Plan');
      expect(elegirPlanButton, findsOneWidget);

      await tester.tap(elegirPlanButton);
      await tester.pumpAndSettle();


      expect(find.text('Aceptar'), findsOneWidget);
    });
  });
}
