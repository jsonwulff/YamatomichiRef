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
    return 'Helvetica neue';
  }

  static TextTheme _getTextTheme() {
    return TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText1:
          TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.black),
    );
  }
}
