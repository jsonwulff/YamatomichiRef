import 'package:app/constants/countries.dart';
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
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.grey,
      ),
      hint: Text(hint),
      onSaved: (String value) => onSaved(value),
      validator: (String value) => validator(value),
      value: initialValue,
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      items: getCountriesListTranslated(context).map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
    );
  }
}
