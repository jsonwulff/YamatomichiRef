import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final correctEmail = 'test@mail.com';

  final correctPassword = 'Test1234';
  final tooShortPassword = '12345';
  final tooLongPassword = 'x-=Q9hWrbLG(YmTct,`")7!w@]t+f{n4j;8*N';
  final passwordWithNoUppercaseLetters = 'test1234';
  final passwordWithNoLowercaseLetters = 'TEST1234';
  final passwordWithNoNumbers = 'testTest';

  final correctName = 'Satoshi Nakamoto';

  final empty = '';

  final date1 = '17/03/2021';
  final date2 = '18/03/2021';

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

      test('Given a too long password returns Password must be between 8 and 32 characters', () {
        expect(AuthenticationValidation.validatePassword(tooLongPassword),
            'Password must be between 8 and 32 characters');
      });

      test('Given a too short password returns Password must be between 8 and 32 characters', () {
        expect(AuthenticationValidation.validatePassword(tooShortPassword),
            'Password must be between 8 and 32 characters');
      });

      test('Given a password without uppercase letters returns Password must contain at least 1 capitalized letter', () {
        expect(AuthenticationValidation.validatePassword(passwordWithNoUppercaseLetters),
            'Password must contain at least 1 capitalized letter');
      });

      test('Given a password without lowercase letters returns Password must contain at least 1 lowercase letter', () {
        expect(AuthenticationValidation.validatePassword(passwordWithNoLowercaseLetters),
            'Password must contain at least 1 lowercase letter');
      });

      test('Given a password without numbers returns Password must contain at least 1 number', () {
        expect(AuthenticationValidation.validatePassword(passwordWithNoNumbers),
            'Password must contain at least 1 number');
      });
    });

    group('Testing of the method validateConfirmationPassword', () {
      test('Given a correct confirm password returns null', () {
        expect(
            AuthenticationValidation.validateConfirmationPassword(correctPassword, correctPassword),
            null);
      });

      test(
          'Given an empty string as confirm password returns Password fields is required',
          () {
        expect(
            AuthenticationValidation.validateConfirmationPassword(
                correctPassword, empty),
            'Password fields is required');
      });

      test(
          'Given an non matching confirm password returns Passwords needs to match',
          () {
        expect(
            AuthenticationValidation.validateConfirmationPassword(
                correctPassword, 'aNonMatchingPassword'),
            'Passwords needs to match');
      });
    });
  });

  group('Testing of the method validateNotNull', () {
    test('Given an empty string return Required', () {
      expect(AuthenticationValidation.validateNotNull(empty), 'Required');
    });

    test('Given a non empty string return null', () {
      expect(AuthenticationValidation.validateNotNull('string'), null);
    });
  });

  group('Testing of the method validateDates', () {
    test('Given one empty date return Required', () {
      expect(AuthenticationValidation.validateDates(date1, empty), 'Required');
    });

    test('Given end date before start date return End must be after start', () {
      expect(AuthenticationValidation.validateDates(date1, date2),
          'End must be after start');
    });

    // TODO update
    // test('Given two dates in correct order returns null', () {
    //   expect(AuthenticationValidation.validateDates(date2, date1), null);
    // });
  });

  group('Testing of the method validateDoNothing', () {
    test('Given an empty string returns null', () {
      expect(AuthenticationValidation.validateDoNothing(empty), null);
    });

    test('Given a non empty string returns null', () {
      expect(AuthenticationValidation.validateDoNothing('non-empty'), null);
    });
  });
}
