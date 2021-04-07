import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CalendarService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference calendarEvents;

  CalendarService() {
    calendarEvents = db.collection('calendarEvent');
  }

  Future<String> addNewEvent(Map<String, dynamic> data, EventNotifier eventNotifier) async {
    var ref = await addEventToFirestore(data);
    if (ref != null) await getEvent(ref, eventNotifier);
    return 'Success';
  }

  /*Future<List<Map<String, dynamic>>> getEvents() async {
    var snaps = await calendarEvents.orderBy('startDate').get();
    List<Map<String, dynamic>> events = [];
    snaps.docs.forEach((element) => events.add(element.data()));
    return events;
  }*/

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

  /*Stream<int> getStreamOfParticipants() async* {
    Event event = Provider.of<EventNotifier>(context, listen: true).event
    return getEventParticipants(event.id);
  }*/

  Stream<QuerySnapshot> getStream() {
    return calendarEvents.snapshots();
  }

  Future<void> joinEvent(String eventID) {
    return null;
  }

  Future<bool> deleteEvent(BuildContext context, Event event) async {
    if (await simpleChoiceDialog(context, 'Are you sure you want to delete this event?')) {
      await delete(event);
      return true;
    }
    return false;
  }

  Future<void> highlightEvent(Event event, EventNotifier eventNotifier) async {
    print('highlight event begun');
    // CollectionReference eventRef = FirebaseFirestore.instance.collection('calendarEvent');
    if (event.highlighted) {
      highlight(event, false);
      getEvent(event.id, eventNotifier);
    } else {
      highlight(event, true);
      getEvent(event.id, eventNotifier);
    }
  }
}
