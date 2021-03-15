import 'package:flutter/material.dart';

//   /// A form field with text input and an image to the left of the input
//   ///
//   /// # Summary
//   /// Upon input the [mainController] would be set to the data in the text field, and to
//   /// ensure correct input an [validator] function can be given, which here
//   /// would be [AuthenticationValidation] class, which also can check
//   /// equality between to field (i.e. password and password confirmation form)
//   /// via the optional [optionalController]. At last the text being displayed about the input
//   /// field is [labelText], and the optional image on the left is [iconData]
//   ///
//   /// # Example:
//   /// - mainController: password
//   /// - validator: AuthenticationValidator.validateConfirmationPassword
//   /// - labelText: 'Confirm Password'
//   /// - iconData: Icons.lock
//   /// - optionalController: passCont.text
//   /// - isTextObscured: true
class TextInputFormFieldComponent extends StatefulWidget {
  final TextEditingController mainController;
  final validator;
  final String labelText;
  final IconData iconData;
  final TextEditingController optionalController;
  final bool isTextObscured;
  final double width;

  TextInputFormFieldComponent(
      this.mainController, this.validator, this.labelText,
      {this.iconData,
      this.optionalController,
      this.isTextObscured = false,
      this.width});

  @override
  _TextInputFormFieldComponentState createState() =>
      _TextInputFormFieldComponentState();
}

class _TextInputFormFieldComponentState
    extends State<TextInputFormFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextFormField(
        autofocus: false,
        validator: (data) => widget.optionalController == null
            ? widget.validator(data)
            : widget.validator(data, widget.optionalController.text),
        obscureText: widget.isTextObscured,
        controller: widget.mainController,
        decoration: InputDecoration(
          labelText: widget.labelText,
          icon: widget.iconData != null ? Icon(widget.iconData) : null,
        ),
      ),
    );
  }
}
