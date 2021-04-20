import 'package:flutter/material.dart';

class ThemeDataCustom {
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: Color(0xFF0085EE), // yama blue #0085EE
      // accentColor: Color(0xFFfe6b6b), // yama red #fe6b6b
      backgroundColor: Color(0xffB3DfFC), // yama grey/blue #B3DfFC
      buttonColor: Color(0xFF0085EE), // yama blue
      accentColor: const Color(0xFFFFFFFF), // Totally white for elements that stand out
      splashColor: Color(0xFFFFFFFF), //TODO test if this is ussed in textfields
      fontFamily: _getFontFamily(),
      textTheme: _getTextTheme(),
      scaffoldBackgroundColor: const Color(0xffF9FAFD), // #F9FAFD
      appBarTheme: _getAppBarTheme(),
    );
  }

  static String _getFontFamily() {
    return 'Roboto';
  }

  static TextTheme _getTextTheme() {
    var softColor = Color(0xff545871); // #545871

    return TextTheme(
      headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900, color: softColor),
      headline3: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: softColor),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: softColor),
      bodyText2:
          TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: softColor, height: 1.5),
    );
  }

  static AppBarTheme _getAppBarTheme() {
    return AppBarTheme(color: Color(0xffF9FAFD));
  }
}
