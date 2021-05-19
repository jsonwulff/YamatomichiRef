import 'package:flutter/material.dart';

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({
    Key key,
    this.hint,
    this.label,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.currentRegions,
    this.regionKey,
    this.outlined = false,
    this.useProfileStyling = false,
  }) : super(key: key);

  final GlobalKey<FormFieldState> regionKey;
  final String hint;
  final String label;
  final Function(String) onSaved;
  final Function(String) onChanged;
  final Function(String) validator;
  final String initialValue;
  final List<String> currentRegions;
  final bool outlined;
  final bool useProfileStyling;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: Colors.grey,
      ),
      key: regionKey,
      hint: hint == null ? null : Text(hint),
      onSaved: (String value) => onSaved(value),
      validator: (String value) => validator(value),
      value: initialValue,
      onChanged: (value) => {},
      style: useProfileStyling
          ? TextStyle(color: Color(0xff545871), fontWeight: FontWeight.bold)
          : null,
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
      items: currentRegions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
    );
  }
}
