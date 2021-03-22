import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/main.dart' as app; // Is actually lib/main.dart
import 'integration_test_helpers.dart';

void main() {
  final _emailTest = 'lukas98@live.dk';
  final _passwordTest = 'test1234';
  final alertDialogFinder = find.byKey(Key('BannedUserAlert'));

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigate to support page', () {
    testWidgets('Load main and navigate to supprt',
        (WidgetTester tester) async {
      await tester.pumpWidget(await app.testMain());

      await IntegrationTestHelpers.testUserLogin(
          tester,
          Key('SignInEmail'),
          _emailTest,
          Key('SignInPassword'),
          _passwordTest,
          Key('SignInButton'));

      await tester.pump(Duration(seconds: 2));

      expect(alertDialogFinder, findsOneWidget);
    });
  });
}
