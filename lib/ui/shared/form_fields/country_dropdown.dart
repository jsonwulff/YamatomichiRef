import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({
    Key key,
    this.hint,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  final String hint;
  final Function(String) onSaved;
  final Function(String) validator;
  final Function(String) onChanged;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Icon(Icons.keyboard_arrow_down_outlined),
      hint: Text(hint),
      onSaved: (String value) => onSaved(value),
      validator: (String value) => validator(value),
      value: initialValue,
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      items: countriesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
    );
  }
}
