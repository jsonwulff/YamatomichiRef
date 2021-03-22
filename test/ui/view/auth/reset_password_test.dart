import 'package:app/ui/view/auth/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helper/create_app_helper.dart';

void main() {
  final buttonToOpenAlert = find.byKey(Key('ButtonToPress'));
  final alertTitleFinder = find.byKey(Key('ResetPassword_ResetPasswordText'));
  final mailInputFinder = find.byKey(Key('ResetPassword_EmailInputFormField'));
  final sendMailButtonFinder = find.byKey(Key('ResetPassword_SendMailButton'));
  final cancelButtonFinder = find.byKey(Key('ResetPassword_CancelButton'));

  testWidgets('Ensure everything loads when opening reset password alert',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        CreateAppHelper.generateYamatomichiTestAppAlertDialog(
            resetPasswordAlertDialog));

    await tester.tap(buttonToOpenAlert);
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(alertTitleFinder, findsOneWidget);
    expect(mailInputFinder.first, findsOneWidget); // why is two created?
    expect(sendMailButtonFinder, findsOneWidget);
    expect(cancelButtonFinder, findsOneWidget);
  });
}
