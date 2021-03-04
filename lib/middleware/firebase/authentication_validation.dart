import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:validators/validators.dart';

class AuthenticationValidation {
  static String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter an email';
    } else if (!isEmail(email)) {
      return 'Please provide a valid email';
    }
  }

  static String validateName(String name) {
    if (name.isEmpty) {
      return 'Please enter your name';
    }
  }

  static String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password fields is required';
    } else if (!isLength(password, 6, 32)) {
      return "Password must be between 6 and 32 characters";
    }
  }

  static String validateConfirmationPassword(
      String password1, String password2) {
    if (password2.isEmpty) {
      return 'Password fields is required';
    } else if (password1 != password2) {
      return 'Passwords needs to match';
    }
  }
}
