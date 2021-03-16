import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

import 'setup_firebase_auth_mock.dart';

class FirebaseMock extends Mock implements Firebase {}
class FirebaseAuthMock extends Mock implements FirebaseAuth {}

main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  final firebaseAuthMock = FirebaseAuthMock();
  final authenticationService = AuthenticationService(firebaseAuthMock);
  final email = 'test@mail.com';
  final password = "test1234";

  group('Sign up firebase mock verification exceptions', () {
    // TODO: firestore mock
    // test('Given correct email and password return success', () async {
    //   when(firebaseAuthMock.createUserWithEmailAndPassword(
    //           email: email, password: password))
    //       .thenAnswer((realInvocation) => null);

    //   expect(
    //       await authenticationService.signUpUserWithEmailAndPassword(
    //           email: email, password: password),
    //       'Success');
    // });

    test(
        'Given password that is too weak (defined by firebase) return The password provided is too weak',
        () async {
      when(firebaseAuthMock.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'weak-password', message: ''));

      expect(
          await authenticationService.signUpUserWithEmailAndPassword(
              email: email, password: password),
          'The password provided is too weak');
    });

    test(
        'Given email that is already in use return The account already exists for that email',
        () async {
      when(firebaseAuthMock.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(
              FirebaseAuthException(code: 'email-already-in-use', message: ''));

      expect(
          await authenticationService.signUpUserWithEmailAndPassword(
              email: email, password: password),
          'The account already exists for that email');
    });

    test('Given invalid email return The email is not valid', () async {
      when(firebaseAuthMock.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'email-invalid', message: ''));

      expect(
          await authenticationService.signUpUserWithEmailAndPassword(
              email: email, password: password),
          'The email is not valid');
    });
  });

  group('Sign in firebase mock verification exceptions', () {
    // test('Given valid login email and password returns Success', () async {
    //   when(firebaseAuthMock.signInWithEmailAndPassword(
    //           email: email, password: password))
    //       .thenAnswer((realInvocation) => null);

    //   expect(
    //       await authenticationService.signInUserWithEmailAndPassword(
    //           email: email, password: password),
    //       'Success');
    // });

    test('Given invalid email returns The email is not valid', () async {
      when(firebaseAuthMock.signInWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'invalid-email', message: ''));

      expect(
          await authenticationService.signInUserWithEmailAndPassword(
              email: email, password: password),
          'The email is not valid');
    });
    
    test('Given disabeled account returns This user account has been disabled', () async {
      when(firebaseAuthMock.signInWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'user-disabled', message: ''));

      expect(
          await authenticationService.signInUserWithEmailAndPassword(
              email: email, password: password),
          'This user account has been disabled');
    });
    
    test('Given password and email that does not match a user returns There is no user corresponding to the given email', () async {
      when(firebaseAuthMock.signInWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(
              FirebaseAuthException(code: 'user-not-found', message: ''));

      expect(
          await authenticationService.signInUserWithEmailAndPassword(
              email: email, password: password),
          'There is no user corresponding to the given email');
    });

    test('Given wrong password return Email or password was wrong', () async {
      when(firebaseAuthMock.signInWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(
              FirebaseAuthException(code: 'wrong-password', message: ''));

      expect(
          await authenticationService.signInUserWithEmailAndPassword(
              email: email, password: password),
          'Email or password was wrong');
    });
  });
}
