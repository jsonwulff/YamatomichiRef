import 'package:flutter/material.dart';

Color generateColor(String email) {
  int hash = email.hashCode.abs();
  int red = ((hash % 12) * 16) + 31;
  hash ~/= 65536;
  int green = ((hash % 12) * 16) + 31;
  hash ~/= 65536;
  int blue = ((hash % 12) * 16) + 31;
  return Color.fromARGB(255, red, green, blue);
}
