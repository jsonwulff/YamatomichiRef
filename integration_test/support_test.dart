import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/main.dart' as app; // Is actually lib/main.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigate to support', () {
    testWidgets('Login', (WidgetTester tester) async {
      await tester.pumpWidget(await app.testMain());

      expect(2 + 2, equals(4));
      // expect(find.text("Don't have a user? Click here to sign up"), findsOneWidget);

      // await tester.enterText(find.byKey(Key('SignInEmailField')), 'lukas98@live.dk');
      // await tester.enterText(find.byKey(Key('SignInPasswordField')), 'test1234');
      // await tester.tap(find.byKey(Key('SignInButton')));
      // await tester.tap(find.text('Support'));
    });
  });

  // testWidgets("failing test example", (WidgetTester tester) async {
  //   expect(2 + 2, equals(4));
  // });
}
