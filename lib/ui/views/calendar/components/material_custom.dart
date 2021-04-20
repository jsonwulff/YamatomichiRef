import 'package:flutter/material.dart';

class MaterialCustom {
  static Material standard(Widget theChild) {
    return Material(
      elevation: 5.0,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.circular(18.0),
      child: theChild,
    );
  }
}