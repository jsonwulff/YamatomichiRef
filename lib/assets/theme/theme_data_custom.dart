import 'package:flutter/material.dart';

class ThemeDataCustom {
  static ThemeData getThemeData() {
    return ThemeData(
      primaryColor: Color(0xFF0085EE), // yama blue #0085EE
      // accentColor: Color(0xFFfe6b6b), // yama red #fe6b6b
      backgroundColor: Color(0xffB3DfFC), // yama grey/blue #B3DfFC
      buttonColor: Color(0xFF0085EE), // yama blue
      accentColor:
          const Color(0xFFFFFFFF), // Totally white for elements that stand out
      splashColor: Color(0xFFFFFFFF), //TODO test if this is ussed in textfields
      fontFamily: _getFontFamily(),
      textTheme: _getTextTheme(),
      scaffoldBackgroundColor: const Color(0xffF9FAFD), // #F9FAFD
      appBarTheme: _getAppBarTheme(),
      inputDecorationTheme: _getInputDecorationTheme(),
    );
  }

  static String _getFontFamily() {
    return 'Roboto';
  }

  static TextTheme _getTextTheme() {
    var softColor = Color(0xff545871); // #545871

    return TextTheme(
      headline1: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline2: TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.w900, color: softColor),
      headline3: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: softColor),
      headline4: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText1: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w600, color: softColor),
      bodyText2: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: softColor,
          height: 1.5),
    );
  }

  static AppBarTheme _getAppBarTheme() {
    return AppBarTheme(
        color: Color(0xffF9FAFD),
        iconTheme: IconThemeData(color: Colors.black));
  }

  // NOTE: calendar event widget nedd text with body size 10
  static TextTheme calendarEventWidgetText() {
    var softColor = Color(0xff545871); // #545871

    return TextTheme(
      bodyText1: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w300,
        color: softColor,
      ),
    );
  }

  static InputDecorationTheme _getInputDecorationTheme() {
    return InputDecorationTheme(
      labelStyle:
          TextStyle(fontWeight: FontWeight.normal, color: Color(0xff545871)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0x80000000), width: 1.5),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0x80000000), width: 1.5),
      ),
    );
  }
}
