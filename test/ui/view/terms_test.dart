import 'package:app/ui/views/auth/sign_up.dart';
import 'package:app/ui/views/terms.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../helper/create_app_helper.dart';
import '../../middleware/firebase/setup_firebase_auth_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Ensure everything from support is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestApp(TermsView()));

    expect(find.byKey(Key('Terms_RichText')), findsOneWidget);
  });

  testWidgets('Ensure that sign up cant be submitted before terms and condations are accepted',
      (WidgetTester tester) async {
    await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestApp(SignUpView()));
    final SignUpViewState signUpViewState = tester.state(find.byType(SignUpView));

    await tester.enterText(find.byKey(Key('SignUp_FirstNameFormField')), 'Anders');
    await tester.enterText(find.byKey(Key('SignUp_LastNameFormField')), 'Andersen');
    await tester.enterText(find.byKey(Key('SignUp_EmailFormField')), 'test@test.dk');
    await tester.enterText(find.byKey(Key('SignUp_PasswordFormField')), '123456');
    await tester.enterText(find.byKey(Key('SignUp_ConfirmPasswordFormField')), '123456');

    await tester.pump(Duration(milliseconds: 100));
    await tester.tap(find.byKey((Key('SignUp_SignUpButton'))));

    expect(signUpViewState.agree, false);

    await tester.tap(find.byKey(Key('Terms_checkbox')));
    await tester.pumpAndSettle();
    expect(signUpViewState.agree, true);
  });
}
