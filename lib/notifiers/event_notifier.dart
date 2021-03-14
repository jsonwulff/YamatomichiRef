import 'package:app/models/event.dart';
import 'package:flutter/material.dart';

class EventNotifier with ChangeNotifier {
  Event _event;

  Event get event => _event;

  set event(Event event) {
    _event = event;
    print('event set in notifier');
    notifyListeners();
  }
}
