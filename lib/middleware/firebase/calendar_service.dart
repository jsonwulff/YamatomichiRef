import 'package:app/middleware/api/event_api.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CalendarService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference calendarEvents;

  CalendarService() {
    calendarEvents = db.collection('calendarEvent');
  }

  Future<String> addNewEvent(
      Map<String, dynamic> data, EventNotifier eventNotifier) async {
    print('addNewEvent: ' + data['description']);
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
}
