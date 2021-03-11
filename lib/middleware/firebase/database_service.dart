import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference calendarEvents;

  DatabaseService() {
    calendarEvents = db.collection('calendarEvent');
  }

  Future<void> addEvent(Map<String, dynamic> data) {
    if ((data['title'] ??
            data['description'] ??
            data['fromDate'] ??
            data['toDate']) ==
        null) return throw Exception('event not fulfilled correctly');

    return calendarEvents.add({
      'title': data['title'],
      'description': data['description'],
      //'price': ...,
      //'capacity': ...,
      //'category': ...,
      //'Meeting': ...,
      //'Dissolution': ...,
      //'deadline' ...,
      'fromDate': data['fromDate'],
      'toDate': data['toDate']
    });
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    var snaps = await calendarEvents.orderBy('fromDate').get();
    List<Map<String, dynamic>> events = [];
    snaps.docs.forEach((element) => events.add(element.data()));
    //events.sort((a, b) => a['fromDate'].compareTo(b['fromDate']));
    return events;
  }

  Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
    var snaps = await calendarEvents
        .where('fromDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(date),
            isLessThan: Timestamp.fromDate(date.add(Duration(hours: 24))))
        .orderBy('fromDate')
        .get();
    List<Map<String, dynamic>> events = [];

    snaps.docs.forEach((element) => events.add(element.data()));
    return events;
  }

  Stream<QuerySnapshot> getStream() {
    return calendarEvents.snapshots();
  }
}
