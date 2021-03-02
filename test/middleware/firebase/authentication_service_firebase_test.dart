import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebase extends Mock implements FirebaseAuth {}

main() {
  group('Sign Up', () {
    final firebase = MockFirebase();
    final authenticationService = AuthenticationService(firebase);

    test(
        'Given test@mail.com and test1234 to authentication services return The account already exists for that email.',
        () async {
          String email = 'test@mail.com';
          String password = "test1234";

      when(firebase.createUserWithEmailAndPassword(email: email, password: password))
      .thenThrow(new FirebaseAuthException(code: 'email-already-in-use', message: 'nope'));

          // .thenThrow((_) async => new FirebaseAuthException(
          //     code: 'email-already-in-use', message: 'empty'));

      expect(
          await authenticationService.signUpUserWithEmailAndPassword(
              email: email, password: password),
          'The account already exists for that email.');
    });
  });
}
