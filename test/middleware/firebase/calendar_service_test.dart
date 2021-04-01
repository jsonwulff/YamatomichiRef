import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/models/event.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'setup_firebase_auth_mock.dart';

class FirebaseMock extends Mock implements Firebase {}

main() {
  setupFirebaseAuthMocks();

  CalendarService calendarService;
  EventNotifier notifier;

  setUpAll(() async {
    await Firebase.initializeApp();
    calendarService = CalendarService();
    notifier = EventNotifier();
  });

  //final calendarService = CalendarService();
  //final notifier = EventNotifier();
  final event1 = Event();
  final event2 = Event(highlighted: true);

  group('highlight event', () {
    test('Given event not highlighted, updates event to highlighted', () async {
      /* await Firebase.initializeApp();
      final calendarService = CalendarService();
      final notifier = EventNotifier(); */
      await calendarService.highlightEvent(event1, notifier);

      print('actual ' + event1.highlighted.toString());

      expect(event1.highlighted, Event(highlighted: true).highlighted);
    });

    /*test('given event highlighted, updates event to not highlighted', () {
      calendarService.highlightEvent(event2, notifier);

      expect(event2.highlighted, Event(highlighted: false).highlighted);
    });*/
  });
}
