import 'package:flutter/material.dart';

// TODO : replace ElevatedButton with this custom widget
class Button extends StatelessWidget {
  Button(
      {Key key,
      this.label,
      this.onPressed,
      this.width,
      this.height,
      this.backgroundColor})
      : super(key: key);

  final String label;
  final dynamic onPressed;
  final double width;
  final double height;
  Color backgroundColor =
      Color.fromRGBO(0, 122, 255, 1.0); // Blue color defined here

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        child: Text(
          label,
        ),
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          textStyle: Theme.of(context).textTheme.headline4,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
