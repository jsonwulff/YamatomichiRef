import 'package:flutter/material.dart';

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({
    Key key,
    this.hint,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.currentRegions,
    this.regionKey,
  }) : super(key: key);

  final GlobalKey<FormFieldState> regionKey;
  final String hint;
  final Function(String) onSaved;
  final Function(String) validator;
  final String initialValue;
  final List<String> currentRegions;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Icon(Icons.keyboard_arrow_down_outlined),
      key: regionKey,
      hint: Text(hint),
      onSaved: (String value) => onSaved(value),
      validator: (String value) => validator(value),
      value: initialValue,
      onChanged: (value) {},
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      items: currentRegions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(value: value, child: Text(value));
      }).toList(),
    );
  }
}
