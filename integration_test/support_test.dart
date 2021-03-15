import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:app/main.dart' as app; // Is actually lib/main.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigate to support', () {
    testWidgets('Login', (WidgetTester tester) async {
      await tester.pumpWidget(await app.testMain());

      expect(find.text("Don't have a user? Click here to sign up"), findsOneWidget);
    });
  });
}
