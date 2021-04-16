import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String errorMessage;
  final String labelText;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final TextInputType textInputType;
  final Key key;
  final EdgeInsetsGeometry margins;
  final String initialValue;
  final TextEditingController textEditingController;

  const CustomTextFormField(this.errorMessage, this.labelText, this.maxLength,
      this.minLines, this.maxLines, this.textInputType, this.margins,
      {this.key, this.initialValue, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margins,
      child: TextFormField(
        controller: textEditingController,
        validator: (value) {
          if (value.trim().isEmpty) {
            return errorMessage;
          }
          return null;
        },
        // style: new TextStyle(fontSize: 14.0),
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: textInputType,
        // textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: labelText,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }
}
