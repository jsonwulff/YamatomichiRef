import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventApi {
  FirebaseFirestore _store;

  EventApi({FirebaseFirestore store}) {
    store != null ? _store = store : _store = FirebaseFirestore.instance;
  }

  /*changeSource(FirebaseFirestore store) {
    _store = store;
  }*/

  addEventToFirestore(Map<String, dynamic> data) async {
    //List<String> foo = List.from(data['participants']);

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
    newEvent.participants = [data['createdBy']];
    newEvent.meeting = data['meeting'];
    newEvent.dissolution = data['dissolution'];
    newEvent.imageUrl = data['imageUrl'];
    newEvent.mainImage = data['mainImage'];
    newEvent.startDate = Timestamp.fromDate(data['startDate']);
    newEvent.endDate = Timestamp.fromDate(data['endDate']);
    newEvent.deadline = Timestamp.fromDate(data['deadline']);
    newEvent.createdAt = Timestamp.now();
    newEvent.updatedAt = Timestamp.now();
    newEvent.allowComments = data['allowComments'];

    CollectionReference calendarEvents = _store.collection('calendarEvent');

    DocumentReference ref = await calendarEvents.add(newEvent.toMap());
    await calendarEvents.doc(ref.id).update({
      "id": ref.id,
    });
    return ref.id;
  }

  getEventAsStream(String eventID) {
    return _store.collection('calendarEvent').doc(eventID).snapshots();
  }

  getEventAsStream2(String eventID) async {
    var stream = _store.collection('calendarEvent').doc(eventID).snapshots();
    return stream;
  }

  getEvent(String eventID, EventNotifier eventNotifier) async {
    DocumentSnapshot snapshot = await _store.collection('calendarEvent').doc(eventID).get();
    if (snapshot.data() == null) return;
    Event event = Event.fromFirestore(snapshot);
    eventNotifier.event = event;
    print('getEvent called');
  }

  update(Event event, Map<String, dynamic> map) async {
    CollectionReference eventRef = _store.collection('calendarEvent');
    event.updatedAt = Timestamp.now();
    await eventRef.doc(event.id).update(map);
  }

  delete(Event event) async {
    CollectionReference eventRef = _store.collection('calendarEvent');
    await eventRef.doc(event.id).delete();
  }
}
