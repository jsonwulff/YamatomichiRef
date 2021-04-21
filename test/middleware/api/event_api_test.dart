import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../firebase/setup_firebase_auth_mock.dart';

class FirebaseMock extends Mock implements Firebase {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class MockBuildContext extends Mock implements BuildContext {}

//class MockFirestoreInstance extends Mock implements FirebaseFirestore {}

@GenerateMocks([])
main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test('update event', () async {
    final event3 = Event(title: 'title');
    final ffMock = MockFirestoreInstance();
    final store = ffMock.collection('calendarEvent');
    await store.add(event3.toMap());
    var snaps = await ffMock.collection('calendarEvent').get();
    store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
    event3.id = snaps.docs.first.id;

    changeSource(ffMock);

    func(Event event) {}

    //await updateEvent(event3, func, {'title': 'updated title'});

    snaps = await ffMock
        .collection('calendarEvent')
        .where('id', isEqualTo: event3.id)
        .get();

    expect(snaps.docs.first.data()['title'], 'updated title');
  });

  test('delete event', () async {
    final event4 = Event();
    final ffMock = MockFirestoreInstance();
    final store = ffMock.collection('calendarEvent');
    await store.add(event4.toMap());
    var snaps = await ffMock.collection('calendarEvent').get();
    store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
    event4.id = snaps.docs.first.id;

    changeSource(ffMock);

    //await delete(event4);

    snaps = await ffMock
        .collection('calendarEvent')
        .where('id', isEqualTo: event4.id)
        .get();
    expect(snaps.docs, []);
  });
}
