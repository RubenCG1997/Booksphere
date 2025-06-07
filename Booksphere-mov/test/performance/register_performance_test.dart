import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/view/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Performance test: StepperRegister builds quickly', (WidgetTester tester) async {
    final emailController = TextEditingController(text: 'test@example.com');
    final passwordController = TextEditingController(text: '123456');
    final usernameController = TextEditingController(text: 'username');

    final widget = MaterialApp(
      home: Scaffold(
        body: StepperRegister(
          emailController: emailController,
          passwordController: passwordController,
          usernameController: usernameController,
        ),
      ),
    );

    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    stopwatch.stop();

    print('Build time: ${stopwatch.elapsedMilliseconds} ms');
    
    expect(stopwatch.elapsedMilliseconds, lessThan(500));
  });
}
