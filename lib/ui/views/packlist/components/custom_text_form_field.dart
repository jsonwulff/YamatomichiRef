import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
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
  final TextEditingController controller;
  final dynamic validator;
  FilteringTextInputFormatter inputFormatter;

  CustomTextFormField(this.errorMessage, this.labelText, this.maxLength,
      this.minLines, this.maxLines, this.textInputType, this.margins,
      {this.key,
      this.initialValue,
      this.controller,
      this.validator,
      this.inputFormatter}) {
    if (inputFormatter == null)
      inputFormatter = FilteringTextInputFormatter.singleLineFormatter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margins,
      child: TextFormField(
        controller: controller,
        inputFormatters: [inputFormatter ?? null],
        validator: (data) => validator(data, context: context),
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: textInputType,
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            labelText: labelText,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }
}
