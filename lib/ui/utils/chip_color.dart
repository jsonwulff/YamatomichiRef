import 'package:flutter/material.dart';

Color chooseChipColor(String category) {
  var categoryColorMap = Map<String, Color>();
  categoryColorMap['Hiking'] = Color(0xffF94144);
  categoryColorMap['Trail running'] = Color(0xfff3722c);
  categoryColorMap['Fast packing'] = Color(0xfff8961e);
  categoryColorMap['Ski'] = Color(0xfff9844a);
  categoryColorMap['Run'] = Color(0xfff9c74f);
  categoryColorMap['Popup'] = Color(0xff90be6d);
  categoryColorMap['UL 101'] = Color(0xff43aa8b);

  categoryColorMap['Bicycling'] = Color(0xff277da1);
  categoryColorMap['Snow Hiking'] = Color(0xff277da1);
  categoryColorMap['Workshop'] = Color(0xff277da1);
  categoryColorMap['Seminar'] = Color(0xff277da1);
  categoryColorMap['Exhibition'] = Color(0xff277da1);
  categoryColorMap['Shop'] = Color(0xff277da1);
  categoryColorMap['Others'] = Color(0xff277da1);
  categoryColorMap['MYOG Workshop'] = Color(0xff4d908e);
  categoryColorMap['Repair Workshop'] = Color(0xff577590);
  categoryColorMap['UL Hiking Lecture'] = Color(0xff277da1);
  categoryColorMap['UL hiking Workshop'] = Color(0xff277da1);
  categoryColorMap['UL Hiking Practice'] = Color(0xff277da1);
  categoryColorMap['Ambassador’s Signature'] = Color(0xff277da1);
  categoryColorMap['Guest Seminar'] = Color(0xff277da1);
  categoryColorMap['Local Study Hiking'] = Color(0xff277da1);
  categoryColorMap['Yamatomichi Festival'] = Color(0xff277da1);

  return categoryColorMap[category] == null ? Color(0xff277da1) : categoryColorMap[category];
}
