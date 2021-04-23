import 'package:app/middleware/api/comment_api.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  CommentService _commentService;
  CommentApi _commentApi;
  MockFirestoreInstance _firestore;
  String docID;

  setUp(() async {
    _firestore = MockFirestoreInstance();
    _commentApi = CommentApi(store: _firestore);
    _commentService = new CommentService(api: _commentApi);

    final event3 = Event(
      startDate: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
      endDate: Timestamp.fromDate(DateTime(2021, 01, 02, 0, 0, 0)),
      deadline: Timestamp.fromDate(DateTime(2021, 01, 01, 0, 0, 0)),
    );
    var store = _firestore.collection('calendarEvent');
    await store.add(event3.toMap());
    var snaps = await store.get();
    store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
    docID = snaps.docs.first.id;
  });

  group('add comment', () {
    test(
        'addComment given a map, collection and document refenrece adds a new comment with the given data',
        () async {
      var comment = {'comment': 'hello'};

      await _commentService.addComment(comment, DBCollection.Calendar, docID);

      var snap = await _firestore
          .collection('calendarEvent')
          .doc(docID)
          .collection('comments')
          .get();
      expect(snap.docs.length, 1);
      expect(snap.docs.first.data()['comment'], 'hello');
    });
  });
}
