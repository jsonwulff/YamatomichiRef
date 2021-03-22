import 'package:app/middleware/api/event_api.dart';
import 'package:app/models/event.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:app/ui/components/pop_up_dialog.dart';
import 'package:app/middleware/api/event_api.dart';

class CalendarService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference calendarEvents;

  CalendarService() {
    calendarEvents = db.collection('calendarEvent');
  }

  Future<String> addNewEvent(
      Map<String, dynamic> data, EventNotifier eventNotifier) async {
    var ref = await addEventToFirestore(data);
    if (ref != null) await getEvent(ref, eventNotifier);
    return 'Success';
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    var snaps = await calendarEvents.orderBy('startDate').get();
    List<Map<String, dynamic>> events = [];
    snaps.docs.forEach((element) => events.add(element.data()));
    return events;
  }

  Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
    var snaps = await calendarEvents
        .where('startDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(date),
            isLessThan: Timestamp.fromDate(date.add(Duration(hours: 24))))
        .orderBy('startDate')
        .get();
    List<Map<String, dynamic>> events = [];

    snaps.docs.forEach((element) => events.add(element.data()));
    return events;
  }

  Stream<QuerySnapshot> getStream() {
    return calendarEvents.snapshots();
  }

  Future<void> joinEvent(String eventID) {
    return null;
  }

  Future<bool> deleteEvent(BuildContext context, Event event) async {
    if (await simpleChoiceDialog(
        context, 'Are you sure you want to delete this event?')) {
      await delete(event);
      return true;
    }
    return false;
  }

  Future<bool> highlightEvent(Event event, EventNotifier eventNotifier) async {
    print('highlight event begun');
    CollectionReference eventRef =
        FirebaseFirestore.instance.collection('calendarEvent');
    if (event.highlighted) {
      await eventRef.doc(event.id).update({'highlighted': false}).then((value) {
        getEvent(event.id, eventNotifier);
        print('event highlighted set to false');
        return true;
      });
    } else {
      await eventRef.doc(event.id).update({'highlighted': true}).then((value) {
        getEvent(event.id, eventNotifier);
        print('event highlighted set to true');
        return true;
      });
    }
    return false;
  }
}
