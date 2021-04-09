//@Skip('Deprecated after refactoring')
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  setupFirebaseAuthMocks();

  CalendarService calendarService;
  EventNotifier notifier;

  setUpAll(() async {
    await Firebase.initializeApp();
    calendarService = CalendarService();
    notifier = EventNotifier();
  });

  group('highlight event', () {
    test('given event not highlighted, updates event to highlighted', () async {
      final event1 = Event(id: '1');
      final ffMock = MockFirestoreInstance();
      await ffMock
          .collection('calendarEvent')
          .add({'id': '1', 'highlighted': false});

      changeSource(ffMock);

      await calendarService.highlightEvent(event1, notifier);

      expect(notifier.event.highlighted, true);
    });

    test('given event highlighted, updates event to not highlighted', () async {
      final event2 = Event(id: '2', highlighted: true);
      final ffMock = MockFirestoreInstance();
      await ffMock
          .collection('calendarEvent')
          .add({'id': '2', 'highlighted': true});

      changeSource(ffMock);

      await calendarService.highlightEvent(event2, notifier);

      expect(notifier.event.highlighted, false);
    });
  });

  /*group('delete event', () {
    test('delete event return true', () async {
      final event3 = Event(id: '3');
      final ffMock = MockFirestoreInstance();
      await ffMock.collection('calendarEvents').add({'id': '3'});

      changeSource(ffMock);

      expect(await calendarService.deleteEvent(mockContext, event3), true);
    });
  });*/

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
