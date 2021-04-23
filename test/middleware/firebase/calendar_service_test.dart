import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

import 'setup_firebase_auth_mock.dart';

class FirebaseMock extends Mock implements Firebase {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class MockBuildContext extends Mock implements BuildContext {}

@GenerateMocks([])
main() {
  CalendarService _calendarService;
  EventApi _eventApi;
  MockFirestoreInstance _firestore;
  EventNotifier notifier = EventNotifier();

  setUp(() async {
    _firestore = MockFirestoreInstance();
    _eventApi = EventApi(store: _firestore);
    _calendarService = new CalendarService(api: _eventApi, store: _firestore);
  });

  group('add new event', () {
    test('given event data, event is added to firestore', () async {
      var map = {
        'title': 'hello',
        'startDate': DateTime(2021, 01, 01, 0, 0, 0),
        'endDate': DateTime(2021, 01, 02, 0, 0, 0),
        'deadline': DateTime(2021, 01, 01, 0, 0, 0)
      };
      _calendarService.addNewEvent(map, notifier);

      var snapshot = await _firestore.collection('calendarEvent').get();
      var size = snapshot.docs.toList().length;

      expect(size, 1);
    });
  });

  group('get Events', () {
    test('getEvents returns all events ordered by their startDate', () async {
      var event1 = ({
        'title': 'second',
        'startDate': DateTime(2021, 01, 01, 1, 0, 0),
        'endDate': DateTime(2021, 01, 02, 0, 0, 0),
        'deadline': DateTime(2021, 01, 01, 0, 0, 0)
      });
      var event2 = ({
        'title': 'first',
        'startDate': DateTime(2021, 01, 01, 0, 0, 0),
        'endDate': DateTime(2021, 01, 02, 0, 0, 0),
        'deadline': DateTime(2021, 01, 01, 0, 0, 0)
      });
      _firestore.collection('calendarEvent').add(event1);
      _firestore.collection('calendarEvent').add(event2);

      var list = await _calendarService.getEvents();

      expect(list.length, 2);
      expect(list.first['title'], 'first');
      expect(list.last['title'], 'second');
    });
  });

  group('get events by user', () {
    test(
        'getEventsByUser given a userprofile returns all event the user has either created or participated in',
        () async {
      UserProfile userProfile = UserProfile(id: '1');
      var event1 = ({
        'startDate': DateTime(2021, 01, 01, 1, 0, 0),
        'endDate': DateTime(2021, 01, 02, 0, 0, 0),
        'deadline': DateTime(2021, 01, 01, 0, 0, 0),
        'createdBy': '1'
      });
      var event2 = ({
        'startDate': DateTime(2021, 01, 01, 0, 0, 0),
        'endDate': DateTime(2021, 01, 02, 0, 0, 0),
        'deadline': DateTime(2021, 01, 01, 0, 0, 0),
        'participants': ['1', '2']
      });
      _firestore.collection('calendarEvent').add(event1);
      _firestore.collection('calendarEvent').add(event2);

      var list = await _calendarService.getEventsByUser(userProfile);

      expect(list.length, 2);
    });
  });

  //NOT DONE!!!!
  /*group('get stream of participants', () {
    test(
        'getStreamOfParticipants given an event notifier returns a stream of the participants from the event in the notifier',
        () async {
      final event3 = Event(
          startDate: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
          endDate: Timestamp.fromDate(DateTime(2021, 01, 02, 0, 0, 0)),
          deadline: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
          participants: ['1', '2']);
      var store = _firestore.collection('calendarEvent');
      await store.add(event3.toMap());
      var snaps = await store.get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      event3.id = snaps.docs.first.id;
      notifier.event = event3;

      var list = _calendarService.getStreamOfParticipants(notifier);

      expect(list.length, 2);
    });
  });*/

  group('join event', () {
    test(
        'joinEvnet given userID that is already participating in the given eventID the user is removed from participants',
        () async {
      UserProfile userProfile = UserProfile(id: '1');
      final event3 = Event(
          startDate: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
          endDate: Timestamp.fromDate(DateTime(2021, 01, 02, 0, 0, 0)),
          deadline: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
          participants: ['1', '2']);
      var store = _firestore.collection('calendarEvent');
      await store.add(event3.toMap());
      var snaps = await store.get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      event3.id = snaps.docs.first.id;
      notifier.event = event3;

      await _calendarService.joinEvent(event3.id, notifier, userProfile.id);

      var doc =
          await _firestore.collection('calendarEvent').doc(event3.id).get();

      expect(doc.data()['participants'].length, 1);
    });

    test(
        'joinEvnet given userID that is not participating in the given eventID the user is added to participants',
        () async {
      UserProfile userProfile = UserProfile(id: '1');
      final event3 = Event(
          startDate: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
          endDate: Timestamp.fromDate(DateTime(2021, 01, 02, 0, 0, 0)),
          deadline: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
          participants: ['2']);
      var store = _firestore.collection('calendarEvent');
      await store.add(event3.toMap());
      var snaps = await store.get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      event3.id = snaps.docs.first.id;
      notifier.event = event3;

      await _calendarService.joinEvent(event3.id, notifier, userProfile.id);

      var doc =
          await _firestore.collection('calendarEvent').doc(event3.id).get();

      expect(doc.data()['participants'].length, 2);
    });
  });

  group('highlight event', () {
    test('given event not highlighted, updates event to highlighted', () async {
      final event1 = Event(id: '1');
      await _firestore
          .collection('calendarEvent')
          .add({'id': '1', 'highlighted': false});

      await _calendarService.highlightEvent(event1, notifier);

      expect(notifier.event.highlighted, true);
    });

    test('given event highlighted, updates event to not highlighted', () async {
      final event2 = Event(id: '2', highlighted: true);
      await _firestore
          .collection('calendarEvent')
          .add({'id': '2', 'highlighted': true});

      await _calendarService.highlightEvent(event2, notifier);
      var snapshot = await _firestore.collection('calendarEvent').get();
      snapshot.docs.forEach((element) {
        print(element.data());
      });

      expect(notifier.event.highlighted, false);
    });
  });

  group('delete event', () {
    test('after delete event list of events in database equals 0', () async {
      final event3 = Event();
      var store = _firestore.collection('calendarEvent');
      await store.add(event3.toMap());
      var snaps = await store.get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      event3.id = snaps.docs.first.id;

      await _calendarService.deleteEvent(event3);

      var snapshot = await _firestore.collection('calendarEvent').get();
      var size = snapshot.docs.toList().length;

      expect(size, 0);
    });
  });

  /*group('get events', () {
    final event1 = Event(
        id: '1',
        startDate: Timestamp.fromDate(DateTime(2021, 01, 02, 12, 0, 0)));
    final event2 = Event(
        id: '2',
        startDate: Timestamp.fromDate(DateTime(2021, 01, 01, 13, 0, 0)));

    test('getEventsByDate return the correct order of events', () async {
      final ffMock = MockFirestoreInstance();
      await ffMock.collection('calendarEvent').add(event1.toMap());
      await ffMock.collection('calendarEvent').add(event2.toMap());
      final store = ffMock.collection('calendarEvent');
      var snaps = await ffMock.collection('calendarEvent').get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      store.doc(snaps.docs.last.id).update({'id': snaps.docs.last.id});
      event1.id = snaps.docs.first.id;
      event2.id = snaps.docs.last.id;

      calendarService.changeSource(ffMock);

      print(ffMock.dump());

      

      var actual = await calendarService
          .getEventsByDate(DateTime(2021, 01, 01, 0, 0, 0));

      expect(actual, [event2]);
    });
  });*/
}
