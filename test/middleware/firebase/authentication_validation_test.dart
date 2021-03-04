import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebase extends Mock implements FirebaseAuth {}

main() {
  final correctEmail = 'test@mail.com';
  final password = "test1234";

  group('Testing of the function validateEmail', () {
    test('Given a correct email returns null', () {
      expect(AuthenticationValidation.validateEmail(correctEmail), null);
    });
  });
}
