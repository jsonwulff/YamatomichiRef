import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
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

  CustomTextFormField(this.errorMessage, this.labelText, this.maxLength, this.minLines,
      this.maxLines, this.textInputType, this.margins,
      {this.key, this.initialValue, this.controller, this.validator, this.inputFormatter}) {
    if (inputFormatter == null) inputFormatter = FilteringTextInputFormatter.singleLineFormatter;
  }

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margins,
      child: TextFormField(
        autofocus: false,
        controller: widget.controller,
        inputFormatters: [widget.inputFormatter ?? null],
        validator: widget.validator,
        maxLength: widget.maxLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        textCapitalization: TextCapitalization.sentences,
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputType == TextInputType.multiline
            ? TextInputAction.newline
            : TextInputAction.done,
        decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            labelText: widget.labelText,
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }
}
