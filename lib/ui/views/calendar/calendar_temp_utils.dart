import 'dart:collection';

import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Example event class.
class tmpEvent {
  final String title;

  const tmpEvent(this.title);

  @override
  String toString() => title;
}

final kEvents = _kEventSource;

Map<DateTime, List<tmpEvent>> map = {};

bool isSameDayFormatted(DateTime d1, DateTime d2) {
  print("d1 " + d1.toString());
  print("d2 " + d2.toString());
  if (d1 == null || d2 == null) {
    return false;
  }

  String s1 = DateFormat.yMd().format(d1);
  String s2 = DateFormat.yMd().format(d2);

  return s1 == s2;
}

getEvents(List<Map<String, dynamic>> events) {
  map.clear();
  events.forEach((element) {
    doSomething(element);
  });
}

doSomething(Map<String, dynamic> element) {
  Timestamp timestamp = element['startDate'];
  DateTime time = DateTime.parse("${convertDateTimeDisplay(timestamp.toDate().toString())}");

  if (!map.containsKey(time)) {
    map[time] = [];
  }
  map[time].add(tmpEvent(element['title']));
}

String convertDateTimeDisplay(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

final _kEventSource = map;

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
