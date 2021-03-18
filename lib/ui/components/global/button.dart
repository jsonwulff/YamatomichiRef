import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({Key key, this.label, this.routeName, this.onPressed})
      : super(key: key);

  final String label;
  final String routeName;
  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        label,
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        textStyle: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}
