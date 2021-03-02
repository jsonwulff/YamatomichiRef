import 'package:flutter/material.dart';

class TextFormFieldsGenerator {
  
  /// A form field with text input and an image to the left of the input
  /// 
  /// # Summary
  /// Upon input the [value] would be set to the data in the text field, and to
  /// ensure correct input an [validator] function can be given, which here
  /// would be [AuthenticationValidation] class, which also can check 
  /// equality between to field (i.e. password and password confirmation form)
  /// via the optional [value2]. At last the text being displayed about the input
  /// field is [labelText], and the optional image on the left is [iconData]
  /// 
  /// # Example:
  /// - value: password
  /// - validator: AuthenticationValidator.validateConfirmationPassword
  /// - labelText: 'Confirm Password'
  /// - iconData: Icons.lock
  /// - value2: passCont.text
  static TextFormField generateFormField(
      String value, Function validator, String labelText,
      {IconData iconData, String value2, bool isTextObscured = false}) {
    return TextFormField(
      autofocus: false,
      validator: (data) =>
          value2 == null ? validator(data) : validator(data, value2),
      onSaved: (data) => value = data,
      obscureText: isTextObscured,
      decoration: InputDecoration(
        labelText: labelText,
        icon: iconData != null ? Icon(iconData) : null,
      ),
    );
  }
}
