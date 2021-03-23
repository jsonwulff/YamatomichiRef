import 'package:validators/validators.dart';

class AuthenticationValidation {
  static String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter an email';
    } else if (!isEmail(email)) {
      return 'Please provide a valid email';
    }
    return null;
  }

  static String validateName(String name) {
    if (name.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password fields is required';
    } else if (!isLength(password, 6, 32)) {
      return 'Password must be between 6 and 32 characters';
    }
    return null;
  }

  static String validateConfirmationPassword(
      String password1, String password2) {
    if (password2.isEmpty) {
      return 'Password fields is required';
    } else if (password1 != password2) {
      return 'Passwords needs to match';
    }
    return null;
  }

  static String validateNotNull(String field) {
    if (field.isEmpty) {
      return 'Required';
    }
    return null;
  }

  static String validateDates(String end, String start) {
    if (start.toString().isEmpty || end.toString().isEmpty) {
      return 'Required';
    }
    DateTime startDate = DateTime.parse(
        "${start.substring(6, 10)}-${start.substring(3, 5)}-${start.substring(0, 2)}");
    DateTime endDate = DateTime.parse(
        "${end.substring(6, 10)}-${end.substring(3, 5)}-${end.substring(0, 2)}");
    print(startDate.toString() + ' ' + endDate.toString());

    if (startDate.isAfter(endDate)) {
      print('wrong');
      return 'End must be after start';
    }
    return null;
  }

  static String validateDoNothing(String field) {
    return null;
  }
}
