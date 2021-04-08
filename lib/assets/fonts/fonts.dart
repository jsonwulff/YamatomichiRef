import 'package:flutter/material.dart';

class FontThemes {
  static String getFontFamily() {
    return 'Georgia';
  }

  static TextTheme getTextTheme() {
    return TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
    );
  }
}
