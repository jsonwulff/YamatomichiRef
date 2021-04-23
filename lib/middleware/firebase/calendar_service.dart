import 'dart:ffi';
import 'dart:math';
import 'dart:async';

import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/ui/shared/dialogs/pop_up_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CalendarService {
  //final FirebaseFirestore _store = FirebaseFirestore.instance;
  /*CollectionReference calendarEvents;
  FirebaseFirestore _store = FirebaseFirestore.instance;
  UserProfileService userProfileService = UserProfileService();*/
  EventApi _api;
  FirebaseFirestore _store;
  CollectionReference calendarEvents;

  CalendarService({EventApi api, FirebaseFirestore store}) {
    api != null ? _api = api : _api = new EventApi();
    store != null ? _store = store : _store = FirebaseFirestore.instance;
    calendarEvents = _store.collection('calendarEvent');
  }
  /*changeSource(FirebaseFirestore store) {
    _store = store;
  }*/

  /* CalendarService() {
    calendarEvents = _store.collection('calendarEvent');
  } */

  Future<String> addNewEvent(
      Map<String, dynamic> data, EventNotifier eventNotifier) async {
    var ref = await _api.addEventToFirestore(data);
    if (ref != null) await _api.getEvent(ref, eventNotifier);
    return 'Success';
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    var snaps = await calendarEvents.orderBy('startDate').get();
    List<Map<String, dynamic>> events = [];
    snaps.docs.forEach((element) => events.add(element.data()));
    return events;
  }

  /*Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
    var snaps = await calendarEvents
        .where('startDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(date),
            isLessThan: Timestamp.fromDate(date.add(Duration(hours: 24))))
        .orderBy('startDate')
        .get();
    List<Map<String, dynamic>> events = [];

    snaps.docs.forEach((element) => events.add(element.data()));
    return events;
  }*/

  // queries all events related to the provided user
  // both createdBy and participated in
  Future<List<Map<String, dynamic>>> getEventsByUser(UserProfile user) async {
    var snapsCreatedByUser =
        await calendarEvents.where('createdBy', isEqualTo: user.id).get();
    var snapsParticipatedByUser = await calendarEvents
        .where('participants', arrayContains: user.id)
        .get();

    List<Map<String, dynamic>> events = [];
    snapsCreatedByUser.docs.forEach((element) => events.add(element.data()));
    snapsParticipatedByUser.docs
        .forEach((element) => events.add(element.data()));

    return events;
  }

  Stream<List<String>> getStreamOfParticipants(
      EventNotifier eventNotifier) async* {
    //Stream<List<String>> getStreamOfParticipants1(
    //    EventNotifier eventNotifier) async* {
    List<String> participants = [];
    Stream<DocumentSnapshot> stream =
        await _api.getEventAsStream(eventNotifier.event.id);
    await for (DocumentSnapshot s in stream) {
      if (s.data() == null) return;
      participants = Event.fromMap(s.data()).participants.cast<String>();
      yield participants;
    }
  }

  Future<void> joinEvent(
      String eventID, EventNotifier eventNotifier, String userID) async {
    _api.getEvent(eventID, eventNotifier);
    var eventMap = eventNotifier.event.toMap();
    if (eventMap['participants'].contains(userID))
      eventMap['participants'].remove(userID);
    else
      eventMap['participants'].add(userID);
    await _api.update(eventNotifier.event, eventMap);
    _api.getEvent(eventID, eventNotifier);
  }

  Future<void> deleteEvent(Event event) async {
    await _api.delete(event);
  }

  Future<void> updateEvent(
      Event event, Map<String, dynamic> map, Function eventUpdated) async {
    await _api.update(event, map);
    eventUpdated(event);
  }

  Future<bool> highlightEvent(Event event, EventNotifier eventNotifier) async {
    print('highlight event begun');
    if (event.highlighted) {
      await _api.update(event, {'highlighted': false});
      print('event highlighted set to false');
      //highlight(event, false);
      await _api.getEvent(event.id, eventNotifier);
      return true;
    } else {
      await _api.update(event, {'highlighted': true});
      print('event highlighted set to true');
      //highlight(event, true);
      await _api.getEvent(event.id, eventNotifier);
      return true;
    }
  }

  String getDocumentRef(String eventID) {
    return calendarEvents.doc(eventID).toString();
  }
}
