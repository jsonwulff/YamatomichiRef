import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/ui/view/auth/sign_in.dart';
import 'package:app/ui/view/auth/sign_up.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helper/create_app_helper.dart';
import '../../middleware/firebase/setup_firebase_auth_mock.dart';

// class UserMock extends Msock implements User {}

class FirebaseMock extends Mock implements Firebase {}

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

main() {
  setupFirebaseAuthMocks();

  final _nameTest = 'Satoshi Nakamoto';
  final _emailTest = 'test@test.com';
  final _passwordTest = 'test1234';
  final _alertDialogFinder = find.byKey(Key('EmailNotVerifiedAlertDialog'));
  // final _userMock = UserMock();
  // final firebaseAuthMock = FirebaseAuthMock();
  // final authenticationService = AuthenticationService(firebaseAuthMock);

  setUpAll(() async {
    // await Firebase.initializeApp();

  final userMock = MockUser(email: _emailTest);
  final firebaseAuthMock = MockFirebaseAuth(mockUser: userMock);
    // when(userMock.emailVerified).thenReturn(false);
    // when(userMock.email).thenReturn(_emailTest);
    // when(firebaseAuthMock.currentUser).thenReturn(userMock);
  });


  group('Test email not verified alert for sign up', () {
    final _signUpNameFormFieldFinder = find.byKey(Key('SignUp_NameFormField'));
    final _signUpEmailFormFieldFinder =
        find.byKey(Key('SignUp_EmailFormField'));
    final _signUpPasswordFormFieldFinder =
        find.byKey(Key('SignUp_PasswordFormField'));
    final _signUpPasswordConfirmFormFieldFinder =
        find.byKey(Key('SignUp_PasswordConfirmFormField'));
    final _signUpButtonFinder = find.byKey(Key('SignUp_SignUpButton'));

    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(CreateAppHelper.generateBasicApp(SignUpView()));

      await tester.enterText(_signUpNameFormFieldFinder, _nameTest);
      await tester.enterText(_signUpEmailFormFieldFinder, _emailTest);
      await tester.enterText(_signUpPasswordFormFieldFinder, _passwordTest);
      await tester.enterText(
          _signUpPasswordConfirmFormFieldFinder, _passwordTest);
      await tester.tap(_signUpButtonFinder);

      await tester.pump();

      expect(_alertDialogFinder, findsOneWidget);
    });
  });

  group('Test email not verified alert for sign in', () {
    final _signInEmailFormFieldFinder = find.byKey(Key('SignInEmail'));
    final _signInPasswordFormFieldFinder = find.byKey(Key('SignInPassword'));
    final _signInButtonFinder = find.byKey(Key('SignInButton'));

    testWidgets('', (WidgetTester tester) async {
      await tester
          .pumpWidget(CreateAppHelper.generateYamatomichiTestApp(SignInView()));

      await tester.enterText(_signInEmailFormFieldFinder, _emailTest);
      await tester.enterText(_signInPasswordFormFieldFinder, _passwordTest);
      await tester.tap(_signInButtonFinder);

      FirebaseAuth.instance;

      await tester.pumpAndSettle();

      expect(_alertDialogFinder, findsOneWidget);
    });
  });
}
