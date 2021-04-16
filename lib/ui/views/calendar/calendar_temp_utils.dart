import 'dart:collection';

import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:app/middleware/models/event.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDayFormatted,
  hashCode: getHashCode,
)..addAll(_kEventSource);

Map<DateTime, List<Event>> list = {};

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

/*Map<DateTime, List<Event>> _kEventSourceFunc() {
  CalendarService calendarService = CalendarService();
  calendarService.getEvents().then((e) => {
        list.clear(),
        e.forEach((element) => list.add(new Event(element['title']))),
      });
  print(list);
  return Map.fromIterable(list);
}*/

Map<DateTime, List<Event>> getEvents() {
  CalendarService calendarService = CalendarService();
  calendarService.getEvents().then((e) => {
        //list.clear(),
        e.forEach((element) => {doSomething(element)}),
      });
}

doSomething(Map<String, dynamic> element) {
  //print(element);
  List<Event> tmp = [];
  Timestamp timestamp = element['startDate'];
  DateTime time = DateTime.parse(
      "${convertDateTimeDisplay(timestamp.toDate().toString())}");
  if (list.containsKey(time)) {
    tmp = list[time];
  } else {
    tmp = [];
  }
  tmp.add(Event(element['title']));
  list.addAll({time: tmp});
  //print(list.toString());
}

String convertDateTimeDisplay(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

final _kEventSource = getEvents();

/*final _kEventSource = Map.fromIterable(list.(50, (index) => index),
    key: (item) => DateTime.utc(2020, 10, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    DateTime.now(): [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });*/

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
