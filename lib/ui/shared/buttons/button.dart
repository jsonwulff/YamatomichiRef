import 'package:flutter/material.dart';

// TODO : replace ElevatedButton with this custom widget
class Button extends StatelessWidget {
  Button({Key key, this.label, this.onPressed}) : super(key: key);

  final String label;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        label,
      ),
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(0, 122, 255, 1.0), // Blue color defined here
        textStyle: TextStyle(
          color: Colors.white,
          fontFamily: "Helvetica Neue",
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
