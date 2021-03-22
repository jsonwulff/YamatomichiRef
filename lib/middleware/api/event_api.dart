import 'package:app/notifiers/event_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/event.dart';
import 'package:provider/provider.dart';

addEventToFirestore(Map<String, dynamic> data) async {
  Event newEvent = Event();
  newEvent.title = data['title'];
  newEvent.createdBy = data['createdBy']; //currentUser
  newEvent.category = data['category'];
  newEvent.description = data['description'];
  newEvent.equipment = data['equipment'];
  newEvent.requirements = data['requirements'];
  newEvent.country = data['country'];
  newEvent.region = data['region'];
  newEvent.price = data['price'];
  newEvent.payment = data['payment'];
  newEvent.maxParticipants = data['maxParticipants'];
  newEvent.minParticipants = data['minParticipants'];
  newEvent.participants = List<String>.from(data['participants']);
  newEvent.meeting = data['meeting'];
  newEvent.dissolution = data['dissolution'];
  newEvent.imageUrl = data['imageUrl'];
  newEvent.startDate = Timestamp.fromDate(data['startDate']);
  newEvent.endDate = Timestamp.fromDate(data['endDate']);
  newEvent.deadline = Timestamp.fromDate(data['deadline']);
  newEvent.createdAt = Timestamp.now();
  newEvent.updatedAt = Timestamp.now();

  CollectionReference calendarEvents =
      FirebaseFirestore.instance.collection('calendarEvent');

  DocumentReference ref = await calendarEvents.add(newEvent.toMap());
  await calendarEvents.doc(ref.id).update({
    "id": ref.id,
  });
  return ref.id;
}

getEvent(String eventID, EventNotifier eventNotifier) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('calendarEvent')
      .doc(eventID)
      .get();
  Event event = Event.fromFirestore(snapshot);
  eventNotifier.event = event;
  print('getEvent called');
}

updateEvent(
    Event event, Function eventUpdated, Map<String, dynamic> map) async {
  CollectionReference eventRef =
      FirebaseFirestore.instance.collection('calendarEvent');
  event.updatedAt = Timestamp.now();
  await eventRef.doc(event.id).update(map);

  eventUpdated(event);
  print('update event called');
}

delete(Event event) async {
  print('delete event begun');
  CollectionReference eventRef =
      FirebaseFirestore.instance.collection('calendarEvent');
  await eventRef.doc(event.id).delete().then((value) {
    print("event deleted");
  });
}

highlight(Event event) async {
  print('highlight event begun');
  CollectionReference eventRef =
      FirebaseFirestore.instance.collection('calendarEvent');
  await eventRef.doc(event.id).update({'highlighted': true}).then((value) {
    print('event highlighted');
    return true;
  });
}
