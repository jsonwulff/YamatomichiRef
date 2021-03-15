import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/main.dart' as app;

import 'integration_test_helpers.dart'; // Is actually lib/main.dart

void main() {
  final _emailTest = 'lukas98@live.dk';
  final _passwordTest = 'test1234';

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigate to support', () {
    testWidgets('Login', (WidgetTester tester) async {
      await tester.pumpWidget(await app.testMain());

      // Ensure that the page is loaded
      expect(find.text("Don't have a user? Click here to sign up"),
          findsOneWidget);

      await IntegrationTestHelpers.testUserLogin(
          tester,
          Key('SignInEmail'),
          _emailTest,
          Key('SignInPassword'),
          _passwordTest,
          Key('SignInButton'));

      // expect(find.text("Don't have a user? Click here to sign up"),
      //     findsOneWidget);

      // expect(find.byKey(Key('SupportButton')), findsOneWidget);
      expect(find.text('lukas98@live.dk'), findsOneWidget);
    });
  });
}
