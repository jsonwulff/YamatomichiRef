import 'package:flutter/material.dart';

class FormKeys {
  static final titleKey = GlobalKey<FormState>();
  static final deadlineKey = GlobalKey<FormState>();
  static final startDateKey = GlobalKey<FormState>();
  static final startTimeKey = GlobalKey<FormState>();
  static final endDateKey = GlobalKey<FormState>();
  static final endTimeKey = GlobalKey<FormState>();

  static List<GlobalKey<FormState>> keys = [
    titleKey,
    deadlineKey,
    startDateKey,
    startTimeKey,
    endDateKey,
    endTimeKey,
  ];
}
