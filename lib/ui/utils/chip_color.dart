import 'package:flutter/material.dart';

Color chooseChipColor(String category) {
  var categoryColorMap = Map<String, Color>();
  categoryColorMap['0'] = Color(0xff277da1); //Hiking
  categoryColorMap['1'] = Color(0xfff3722c); //Trail running
  categoryColorMap['2'] = Color(0xfff8961e); //Fast packing
  categoryColorMap['3'] = Color(0xfff9844a); //Ski
  categoryColorMap['4'] = Color(0xfff9c74f); //Run
  categoryColorMap['5'] = Color(0xff90be6d); //Popup
  categoryColorMap['6'] = Color(0xff43aa8b); //UL 101

  categoryColorMap['7'] = Color(0xffF94144); //Bicycling
  categoryColorMap['8'] = Color(0xffF94144); //Snow Hiking
  categoryColorMap['9'] = Color(0xffF94144); //Workshop
  categoryColorMap['10'] = Color(0xffF94144); //Seminar
  categoryColorMap['11'] = Color(0xffF94144); //Exhibition
  categoryColorMap['12'] = Color(0xffF94144); //Shop
  categoryColorMap['13'] = Color(0xffF94144); //Others
  categoryColorMap['14'] = Color(0xffF94144); //MYOG Workshop
  categoryColorMap['15'] = Color(0xffF94144); //Repair Workshop

  //Yama only
  categoryColorMap['16'] = Colors.grey; //UL Hiking Lecture
  categoryColorMap['17'] = Colors.grey; //UL hiking Workshop
  categoryColorMap['18'] = Colors.grey; //UL Hiking Practice
  categoryColorMap['19'] = Colors.grey; //Ambassador’s Signature
  categoryColorMap['20'] = Colors.grey; //Guest Seminar
  categoryColorMap['21'] = Colors.grey; //Local Study Hiking
  categoryColorMap['22'] = Colors.grey; //Yamatomichi Festival

  return categoryColorMap[category] == null ? Colors.grey : categoryColorMap[category];
}
