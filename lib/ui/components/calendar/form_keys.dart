import 'package:flutter/material.dart';

class FormKeys {
  static final step1Key = GlobalKey<FormState>();
  static final step2Key = GlobalKey<FormState>();
  static final step3Key = GlobalKey<FormState>();
  static final step4Key = GlobalKey<FormState>();
  static final step5Key = GlobalKey<FormState>();

  static List<GlobalKey<FormState>> keys = [
    step1Key,
    step2Key,
    step3Key,
    step4Key,
    step5Key
  ];
}
