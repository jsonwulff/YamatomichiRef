import 'package:flutter/material.dart';

class TextFormFieldsGenerator {
  static TextFormField generateFormField(
      String value, Function validation, String labelText,
      {IconData iconData, String value2}) {
    return TextFormField(
      autofocus: false,
      validator: (data) =>
          value2 == null ? validation(data) : validation(data, value2),
      onSaved: (data) => value = data,
      decoration: InputDecoration(
        labelText: labelText,
        icon: iconData != null ? Icon(iconData) : null,
      ),
    );
  }
}
