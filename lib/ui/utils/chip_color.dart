import 'package:flutter/material.dart';

Color chooseChipColor(String category) {
  var categoryColorMap = Map<String, Color>();
  categoryColorMap['Hike'] = Color(0xffBEBEBE);
  categoryColorMap['Snow Hike'] = Color(0xffffe2bf);
  categoryColorMap['Fastpacking'] = Color(0xfffac2c6);
  categoryColorMap['Ski'] = Color(0xffffbae3);
  categoryColorMap['Run'] = Color(0xffe1b9ec);
  categoryColorMap['Popup'] = Color(0xffa3b2ff);
  categoryColorMap['UL 101'] = Color(0xffbcf0ff);
  categoryColorMap['MYOG Workshop'] = Color(0xffacfff1);
  categoryColorMap['Repair Workshop'] = Color(0xffa6ffcf);

  return categoryColorMap[category];
}
