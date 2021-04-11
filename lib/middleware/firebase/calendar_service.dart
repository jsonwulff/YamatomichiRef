import 'dart:ffi';
import 'dart:math';

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
  CollectionReference calendarEvents;
  FirebaseFirestore _store = FirebaseFirestore.instance;
  UserProfileService userProfileService = UserProfileService();

  changeSource(FirebaseFirestore store) {
    _store = store;
  }

  CalendarService() {
    calendarEvents = _store.collection('calendarEvent');
  }

  Future<String> addNewEvent(Map<String, dynamic> data, EventNotifier eventNotifier) async {
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

  Stream<List<String>> getStreamOfParticipants(EventNotifier eventNotifier) async* {
    // Event event = eventNotifier.event;
    // await for (var snapshot in getEventParticipants(event.id)) {
    //   for (var participants in snapshot.documents) {
    //     return participants;
    //   }
    // }
    //List<UserProfile> userProfiles = [];
    //for (var participantid in event.participants) {
    //  userProfiles.add(await userProfileService.getUserProfile(participantid));
    //}
    //yield userProfiles;
  }

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
    if (event.highlighted) {
      updateEvent(event, (e) {}, {'highlighted': false});
      print('event highlighted set to false');
      //highlight(event, false);
      getEvent(event.id, eventNotifier);
    } else {
      updateEvent(event, (e) {}, {'highlighted': true});
      print('event highlighted set to true');
      //highlight(event, true);
      getEvent(event.id, eventNotifier);
    }
  }
}
