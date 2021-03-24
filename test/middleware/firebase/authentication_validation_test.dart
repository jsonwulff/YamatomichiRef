import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final correctEmail = 'test@mail.com';

  final correctPassword = 'test1234';
  final tooShortPassword = '12345';
  final tooLongPassword = 'x-=Q9hWrbLG(YmTct,`")7!w@]t+f{n4j;8*N';

  final correctName = 'Satoshi Nakamoto';

  final empty = '';

  group('Testing of the method validateEmail', () {
    test('Given a correct email returns null', () {
      expect(AuthenticationValidation.validateEmail(correctEmail), null);
    });

    test('Given an empty string as email, reutrns Please enter an email', () {
      expect(AuthenticationValidation.validateEmail(empty), 'Please enter an email');
    });

    group('Testing of the method ValidateName', () {
      test('Given a correct name returns null', () {
        expect(AuthenticationValidation.validateFirstName(correctName), null);
      });

      test('Given an empty string as name returns Please enter your name', () {
        expect(AuthenticationValidation.validateFirstName(empty), 'Please enter your first name');
      });
    });

    group('Testing of the method validatePassword', () {
      test('Given a correct password returns null', () {
        expect(AuthenticationValidation.validatePassword(correctPassword), null);
      });

      test('Given an empty string as returns Password fields is required', () {
        expect(AuthenticationValidation.validatePassword(empty), 'Password fields is required');
      });

      test('Given a too long password returns Password must be between 6 and 32 characters', () {
        expect(AuthenticationValidation.validatePassword(tooLongPassword),
            'Password must be between 6 and 32 characters');
      });

      test('Given a too short password returns Password must be between 6 and 32 characters', () {
        expect(AuthenticationValidation.validatePassword(tooShortPassword),
            'Password must be between 6 and 32 characters');
      });
    });

    group('Testing of the method validateConfirmationPassword', () {
      test('Given a correct confirm password returns null', () {
        expect(
            AuthenticationValidation.validateConfirmationPassword(correctPassword, correctPassword),
            null);
      });

      test('Given an empty string as confirm password returns Password fields is required', () {
        expect(AuthenticationValidation.validateConfirmationPassword(correctPassword, empty),
            'Password fields is required');
      });

      test('Given an non matching confirm password returns Passwords needs to match', () {
        expect(
            AuthenticationValidation.validateConfirmationPassword(
                correctPassword, 'aNonMatchingPassword'),
            'Passwords needs to match');
      });
    });
  });
}
