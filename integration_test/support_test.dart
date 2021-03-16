import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/main.dart' as app; // Is actually lib/main.dart
import 'integration_test_helpers.dart';

void main() {
  final _emailTest = 'test@mail.com';
  final _passwordTest = 'test1234';
  WidgetTester tester;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: unused_element
  void setUp() async {
    await tester.pumpWidget(await app.testMain());
  }

  group('Navigate to support page', () async {
    testWidgets('Load main and navigate to supprt',
        (WidgetTester tester) async {
      await IntegrationTestHelpers.testUserLogin(
          tester,
          Key('SignInEmail'),
          _emailTest,
          Key('SignInPassword'),
          _passwordTest,
          Key('SignInButton'));

      await tester.tap(find.byKey(Key('SupportButton')));
      await tester.pump();

      expect(find.byKey(Key('Support_ContactTitle')), findsOneWidget);
    });
  });

  group('test of sending email in contact in support', () async {
    testWidgets('Create and send mail and open native mail application',
        (WidgetTester tester) async {
      await tester.enterText(
          find.byKey(Key('Support_ContactMailSubject')), 'test subject');
      await tester.enterText(
          find.byKey(Key('Support_ContactMailBody')), 'test body');
      await tester.tap(find.byKey(Key('Support_SendMailButton')));

      expect(find.byKey(Key('Support_ContactTitle')), findsNothing);
    });
  });
}
