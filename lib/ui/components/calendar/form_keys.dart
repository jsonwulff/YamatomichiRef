import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormKeys {
  static var step1Key;
  static var step2Key;
  static var step3Key;
  static var step4Key;
  static var step5Key;

  FormKeys() {
    step1Key = GlobalKey<FormState>();
    step2Key = GlobalKey<FormState>();
    step3Key = GlobalKey<FormState>();
    step4Key = GlobalKey<FormState>();
    step5Key = GlobalKey<FormState>();
  }

  static List<GlobalKey<FormState>> keys = [
    step1Key,
    step2Key,
    step3Key,
    step4Key,
    step5Key
  ];
}
