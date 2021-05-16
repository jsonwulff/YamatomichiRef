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

  categoryColorMap['bicycling'] = Color(0xff277da1);
  categoryColorMap['snow hiking'] = Color(0xff277da1);
  categoryColorMap['workshop'] = Color(0xff277da1);
  categoryColorMap['seminar'] = Color(0xff277da1);
  categoryColorMap['exhibition'] = Color(0xff277da1);
  categoryColorMap['shop'] = Color(0xff277da1);
  categoryColorMap['others'] = Color(0xff277da1);
  categoryColorMap['MYOG Workshop'] = Color(0xff4d908e);
  categoryColorMap['Repair Workshop'] = Color(0xff577590);
  categoryColorMap['UL Hiking lecture'] = Color(0xff277da1);
  categoryColorMap['ul hiking workshop'] = Color(0xff277da1);
  categoryColorMap['ul hiking practice'] = Color(0xff277da1);
  categoryColorMap['ambassador’s signature'] = Color(0xff277da1);
  categoryColorMap['guest seminar'] = Color(0xff277da1);
  categoryColorMap['local study hiking'] = Color(0xff277da1);
  categoryColorMap['yamatomichi festival'] = Color(0xff277da1);

  return categoryColorMap[category] == null ? Color(0xff277da1) : categoryColorMap[category];
}
