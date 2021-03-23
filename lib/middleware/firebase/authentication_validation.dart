import 'package:validators/validators.dart';

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
      return 'Password fields is required';
    } else if (!isLength(password, 6, 32)) {
      return 'Password must be between 6 and 32 characters';
    }
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
}
