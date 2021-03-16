import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class IntegrationTestHelpers {
  /// Assumes that the widget has been initialized with
  /// ```dart
  /// await tester.pumpWidget(Main());
  /// ```
  static Future<void> testUserLogin(
      WidgetTester tester,
      Key emailFieldKey,
      String emailToBeEntered,
      Key passwordFieldKey,
      String passwordToBeEntered,
      Key signInButtonKey) async {
    await tester.enterText(find.byKey(emailFieldKey), emailToBeEntered);
    await tester.enterText(find.byKey(passwordFieldKey), passwordToBeEntered);
    await tester.tap(find.byKey(signInButtonKey));
    await tester.pump();
  }

  static Future<void> navigateToSupportPage(
      WidgetTester tester,
      Key emailFieldKey,
      String emailToBeEntered,
      Key passwordFieldKey,
      String passwordToBeEntered,
      Key signInButtonKey,
      Key supportButtonKey) async {
    await tester.enterText(find.byKey(emailFieldKey), emailToBeEntered);
    await tester.enterText(find.byKey(passwordFieldKey), passwordToBeEntered);
    await tester.tap(find.byKey(signInButtonKey));
    await tester.pump();
    
    await tester.tap(find.byKey(supportButtonKey));
    await tester.pump();
  }
}
