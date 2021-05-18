import 'package:flutter/material.dart';

class CalendarNotifier with ChangeNotifier {
  bool _boolean = false;

  bool get boolean => _boolean;

  set boolean(bool boolean) {
    _boolean = boolean;

    notifyListeners();
  }

  remove() {
    _boolean = false;
  }
}
