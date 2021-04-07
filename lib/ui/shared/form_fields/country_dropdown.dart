import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({
    Key key,
    this.hint,
    this.onSaved,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  final String hint;
  final Function(String) onSaved;
  final Function(String) validator;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(hint),
      onSaved: (String value) => onSaved(value),
      validator: (String value) => validator(value),
      value: initialValue,
      onChanged: (value) {},
      items: countriesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
    );
  }
}
