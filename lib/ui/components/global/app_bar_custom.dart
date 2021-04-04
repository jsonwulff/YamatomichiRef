import 'package:flutter/material.dart';

class AppBarCustom {
  static basicAppBar(String text) {
    return AppBar(
      brightness: Brightness.dark,
      title: Text(text),
    );
  }
}
