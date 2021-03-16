import 'package:flutter/material.dart';

class CreateAppHelper {
  static MaterialApp generateBasicApp(Widget widget)
  {
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  }
}