import 'package:flutter/material.dart';

class TextInputFormFieldGenerate extends StatefulWidget {
  TextEditingController mainController;
  var validator;
  final String labelText;
  final IconData iconData;
  TextEditingController optionalController;
  final bool isTextObscured;
  TextEditingController controller;

  TextInputFormFieldGenerate(this.mainController, this.validator, this.labelText,
      {this.iconData, this.optionalController, this.isTextObscured = false});

  @override
  _TextInputFormFieldGenerateState createState() =>
      _TextInputFormFieldGenerateState();
}

class _TextInputFormFieldGenerateState
    extends State<TextInputFormFieldGenerate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        autofocus: false,
        validator: (data) => widget.optionalController == null
            ? widget.validator(data)
            : widget.validator(data, widget.optionalController.text),
        // onSaved: (data) => widget.mainController = data,
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

// class TextFormFieldsGenerator {

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
//   static TextFormField generateFormField(
//       TextEditingController mainController, Function validator, String labelText,
//       {IconData iconData, TextEditingController optionalController, bool isTextObscured = false}) {
//     return TextFormField(
//       autofocus: false,
//       validator: (data) =>
//           optionalController == null ? validator(data) : validator(data, optionalController.text),
//       // onSaved: (data) => mainController = data,
//       obscureText: isTextObscured,
//       decoration: InputDecoration(
//         labelText: labelText,
//         icon: iconData != null ? Icon(iconData) : null,
//       ),
//     );
//   }
// }
