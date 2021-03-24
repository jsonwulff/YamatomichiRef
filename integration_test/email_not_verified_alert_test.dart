import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart' as app; // Is actually lib/main.dart

main() {
  final emailTest = 'test@mail.com';
  final passwordTest = 'test1234';

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final alertDialogFinder = find.byKey(Key('EmailNotVerifiedAlertDialog'));

  final _signInEmailFormFieldFinder = find.byKey(Key('SignInEmail'));
  final _signInPasswordFormFieldFinder = find.byKey(Key('SignInPassword'));
  final _signInButtonFinder = find.byKey(Key('SignInButton'));

  testWidgets(
      'When signing in wiht test@mail.com and test1234 the user has not verified the email hence to not verified email alert is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(await app.testMain());

    await tester.enterText(_signInEmailFormFieldFinder, emailTest);
    await tester.enterText(_signInPasswordFormFieldFinder, passwordTest);
    await tester.tap(_signInButtonFinder);

    await tester.pump(Duration(seconds: 2));

    expect(alertDialogFinder, findsOneWidget);
  });
}
