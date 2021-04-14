import 'package:flutter/material.dart';

class ThemeDataCustom {
  static ThemeData getThemeData() {
    return ThemeData(
      // brightness: Brightness.dark,
      // primaryColor: Colors.lightBlue[800],
      // accentColor: Colors.cyan[600],

      fontFamily: _getFontFamily(),
      textTheme: _getTextTheme(),
    );
  }

  static String _getFontFamily() {
    return 'Roboto';
  }

  static TextTheme _getTextTheme() {
    var softColor = Color(0xff545871);
    return TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: softColor),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
    );
  }
}
