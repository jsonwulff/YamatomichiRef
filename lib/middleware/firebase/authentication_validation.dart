import 'package:flutter/cupertino.dart';
import 'package:validators/validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthenticationValidation {
  static String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter an email';
    } else if (!isEmail(email.trim())) {
      return 'Please provide a valid email';
    }
    return null;
  }

  static String validateFirstName(String name) {
    if (name.isEmpty) {
      return 'Please enter your first name';
    } else if (!isLength(name, 2, 32)) {
      return 'First name must be between 6 and 32 characters';
    }
    return null;
  }

  static String validateLastName(String name) {
    if (name.isEmpty) {
      return 'Please enter your last name';
    } else if (!isLength(name, 2, 32)) {
      return 'Last name must be between 6 and 32 characters';
    }
    return null;
  }

  static String validatePassword(String password) {
    if (password.isEmpty) {
      return "Password fields is required";
    } else if (!isLength(password, 8, 32)) {
      return 'Password must be between 8 and 32 characters';
    } else if (!password.contains(RegExp (r'.*[A-Z].*') )) {
      //todo: implement language variants for these warnings
      return 'Password must contain at least 1 capitalized letter';
    } else if (!password.contains( RegExp ( r'.*\d.*' ))){
      return 'Password must contain at least 1 number';
    } else if (!password.contains( RegExp ( r'.*[a-z].*' ))) {
      return 'Password must contain at least 1 lowercase letter';
    }


      //r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
    return null;
  }

  static String validateConfirmationPassword(String password1, String password2) {
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
