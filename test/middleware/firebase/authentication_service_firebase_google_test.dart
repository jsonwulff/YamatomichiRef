import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import '../../helper/create_app_helper.dart';

main() {
  final uidTest = 'uid';
  final emailTest = 'mail@test.com';
  final displayNameTest = 'Satoshi';

  final googleSignIn = MockGoogleSignIn();
  
  AuthenticationService authenticationService;

  void userInFirebaseSetup() {
    final user = MockUser(
      isAnonymous: false,
      uid: uidTest,
      email: emailTest,
      displayName: displayNameTest,
    );
    
    final firebaseAuthMock = MockFirebaseAuth(mockUser: user);
    authenticationService = AuthenticationService(firebaseAuthMock);
  }
  
  void noUserInFirebaseSetup() {
    final firebaseAuthMock = MockFirebaseAuth();
    authenticationService = AuthenticationService(firebaseAuthMock);
  }

  group('Sign out tests with mocked firebase', () {
    // TODO: sign out
    final buttonToPressFinder = find.byKey(Key('ButtonToPress'));
    // final yesButtonFinder = find.byKey(Key('yes'));
    // final noButtonFinder = find.byKey(Key('no'));

    // testWidgets('Call signout with user pressing yes set currentUser to null', (WidgetTester tester) async {
    //   userInFirebaseSetup();
    //   await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestAppCallFunction(authenticationService.signOut));

    //   await tester.tap(buttonToPressFinder);
    //   await tester.pump();

    //   await tester.tap(find.text('Yes'));
    //   await tester.pumpAndSettle();

    //   expect(authenticationService.firebaseAuth.currentUser, null);
    // });
    
    // testWidgets('Call signout with user pressing yes set currentUser to null', (WidgetTester tester) async {
    //   userInFirebaseSetup();
    //   await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestAppCallFunction(authenticationService.signOut));

    //   await tester.tap(buttonToPressFinder);
    //   await tester.pump();

    //   await tester.tap(yesButtonFinder);
    //   await tester.pump();

    //   expect(authenticationService.firebaseAuth.currentUser, null);
    // });

    testWidgets('Call forceSignOut with a user signed in', (WidgetTester tester) async {
      userInFirebaseSetup();
      await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestAppCallFunction(authenticationService.forceSignOut));

      await tester.tap(buttonToPressFinder);
      await tester.pump();

      expect(authenticationService.firebaseAuth.currentUser, null);
    });
    
    testWidgets('Call forceSignOut with no user signed in does not throw an error', (WidgetTester tester) async {
      noUserInFirebaseSetup();
      await tester.pumpWidget(CreateAppHelper.generateYamatomichiTestAppCallFunction(authenticationService.forceSignOut));

      await tester.tap(buttonToPressFinder);
      await tester.pump();
    });
  });

  // group('Sign in with Google', () {
  //   test('ddfdg', () async {
  //     userInFirebaseSetup();


  //     await authenticationService.signInWithGoogle(googleSignIn: googleSignIn);
  //   });
  // });
}
