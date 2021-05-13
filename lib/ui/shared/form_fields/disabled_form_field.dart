import 'package:flutter/material.dart';

class DisabledFormField extends StatelessWidget {
  const DisabledFormField({
    Key key,
    this.initialValue,
    @required this.labelText,
    this.helperText,
  }) : super(key: key);

  final String initialValue;
  final String labelText;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        initialValue: initialValue ?? '',
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.sentences,
        enabled: false,
        decoration: InputDecoration(
            labelText: labelText,
            helperText: helperText,
            helperStyle: TextStyle(color: Color(0xff545871)),
            suffixIcon: Icon(Icons.edit_off)),
        style: TextStyle(color: Color(0xff545871), fontWeight: FontWeight.bold),
      ),
    );
  }
}
