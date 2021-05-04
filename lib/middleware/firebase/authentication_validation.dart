import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class AuthenticationValidation {
  static String validateEmail(String email, {BuildContext context}) {
    if (email.isEmpty) {
      return context != null
          ? AppLocalizations.of(context).pleaseEnterAnEmail
          : 'Please enter an email';
    } else if (!isEmail(email.trim())) {
      return context != null
          ? AppLocalizations.of(context).pleaseProvideAValidEmail
          : 'Please provide a valid email';
    }
    return null;
  }

  static String validateFirstName(String name, {BuildContext context}) {
    if (name.isEmpty) {
      return context != null
          ? AppLocalizations.of(context).pleaseEnterYourFirstName
          : 'Please enter your first name';
    } else if (!isLength(name, 2, 32)) {
      return context != null
          ? AppLocalizations.of(context).firstNameCharacterLimit
          : 'First name must be between 6 and 32 characters';
    }
    return null;
  }

  static String validateLastName(String name, {BuildContext context}) {
    if (name.isEmpty) {
      return context != null
          ? AppLocalizations.of(context).pleaseEnterYourLastName
          : 'Please enter your last name';
    } else if (!isLength(name, 2, 32)) {
      return context != null
          ? AppLocalizations.of(context).lastNameCharacterLimit
          : 'Last name must be between 6 and 32 characters';
    }
    return null;
  }

  static String validatePassword(String password, {BuildContext context}) {
    if (password.isEmpty) {
      return context != null
          ? AppLocalizations.of(context).passwordFieldsIsRequired
          : 'Password fields is required';
    } else if (!isLength(password, 8, 32)) {
      return context != null
          ? AppLocalizations.of(context).passwordCharacterLimit
          : 'Password must be between 8 and 32 characters';
    } else if (!password.contains(RegExp(r'.*[A-Z].*'))) {
      return context != null
          ? AppLocalizations.of(context).atLeast1CapitalizedLetter
          : 'Password must contain at least 1 capitalized letter';
    } else if (!password.contains(RegExp(r'.*[a-z].*'))) {
      return context != null
          ? AppLocalizations.of(context).atLeast1LowerLetter
          : 'Password must contain at least 1 lowercase letter';
    } else if (!password.contains(RegExp(r'.*\d.*'))) {
      return context != null
          ? AppLocalizations.of(context).atLeast1Number
          : 'Password must contain at least 1 number';
    }

    //r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
    return null;
  }

  static String validateConfirmationPassword(String password1, String password2,
      {BuildContext context}) {
    if (password2.isEmpty) {
      return context != null
          ? AppLocalizations.of(context).passwordFieldsIsRequired
          : 'Password fields is required';
    } else if (password1 != password2) {
      return context != null
          ? AppLocalizations.of(context).passwordFieldsIsRequired
          : 'Passwords needs to match';
    }
    return null;
  }

  static String validateNotNull(String field, {BuildContext context}) {
    if (field.isEmpty) {
      return context != null
          ? AppLocalizations.of(context).required
          : 'Required';
    }
    return null;
  }

  static String validateDates(String end, String start,
      {BuildContext context}) {
    if (start.toString().isEmpty || end.toString().isEmpty) {
      return context != null
          ? AppLocalizations.of(context).required
          : 'Required';
    }
    DateTime startDate = DateTime.parse(
        "${start.substring(6, 10)}-${start.substring(3, 5)}-${start.substring(0, 2)}");
    DateTime endDate = DateTime.parse(
        "${end.substring(6, 10)}-${end.substring(3, 5)}-${end.substring(0, 2)}");
    print(startDate.toString() + ' ' + endDate.toString());

    if (startDate.isAfter(endDate)) {
      return context != null
          ? AppLocalizations.of(context).required
          : 'End must be after start';
    }
    return null;
  }

  static String validateDoNothing(String field) {
    return null;
  }
}
