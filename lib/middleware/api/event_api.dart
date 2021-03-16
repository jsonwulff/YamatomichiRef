import 'package:app/notifiers/event_notifier.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/event.dart';

addEvent(Map<String, dynamic> data) async {
  //String userUID / Current User
  //current event

  Event newEvent = Event();
  newEvent.title = data['title'];
  newEvent.createdBy = data['createdBy']; //currentUser
  newEvent.region = data['region'];
  newEvent.price = data['price'];
  newEvent.payment = data['payment'];
  newEvent.maxParticipants = data['maxParticipants'];
  newEvent.minParticipants = data['minParticipants'];
  newEvent.participants = List<String>.from(data['participants']);
  newEvent.meeting = data['meeting'];
  newEvent.dissolution = data['dissolution'];
  newEvent.imageUrl = data['imageUrl'];
  newEvent.fromDate = Timestamp.fromDate(data['fromDate']);
  newEvent.toDate = Timestamp.fromDate(data['toDate']);
  newEvent.deadline = Timestamp.fromDate(data['deadline']);
  newEvent.createdAt = Timestamp.now();
  newEvent.updatedAt = Timestamp.now();

  CollectionReference calendarEvents =
      FirebaseFirestore.instance.collection('calendarEvent');
  await calendarEvents.doc(newEvent.id).set(newEvent.toMap());
}

setEventNotifier(String eventID, EventNotifier eventNotifier) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('calendarEvent')
      .doc(eventID)
      .get();
  Event _event = Event.fromFirestore(snapshot);
  eventNotifier.event = _event;
  print('getEvent called');
}

getEventsByDate() async {
  CollectionReference calendarEvents =
      FirebaseFirestore.instance.collection('calendarEvent');
  var snaps = await calendarEvents.orderBy('fromDate').get();
  List<Map<String, dynamic>> events = [];
  snaps.docs.forEach((element) => events.add(element.data()));
  return events;
}

updateEvent(Event event, Function eventUpdated) async {
  CollectionReference eventRef =
      FirebaseFirestore.instance.collection('calendarEvent');
  event.updatedAt = Timestamp.now();
  await eventRef.doc(event.id).update(event.toMap());

  eventUpdated(event);
  print('updateUserProfile called');
}
