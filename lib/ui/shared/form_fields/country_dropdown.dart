import 'package:app/constants/countryRegion.dart';
import 'package:flutter/material.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({
    Key key,
    this.hint,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.outlined = false,
    this.label,
    this.useProfileStyling = false,
  }) : super(key: key);

  final String hint;
  final String label;
  final Function(String) onSaved;
  final Function(String) validator;
  final Function(String) onChanged;
  final String initialValue;
  final bool outlined;
  final bool useProfileStyling;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.grey,
      ),
      hint: hint == null ? null : Text(hint),
      onSaved: (String value) => onSaved(value),
      validator: (String value) => validator(value),
      value: initialValue,
      style: useProfileStyling
          ? TextStyle(color: Color(0xff545871), fontWeight: FontWeight.bold)
          : null,
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
        labelText: label == null ? null : label,
        contentPadding: outlined ? EdgeInsets.fromLTRB(20, 16, 20, 16) : null,
        enabledBorder: outlined
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              )
            : null,
        filled: outlined,
        fillColor: outlined ? Theme.of(context).scaffoldBackgroundColor : null,
      ),
      items: getCountriesListTranslated(context).map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
    );
  }
}
