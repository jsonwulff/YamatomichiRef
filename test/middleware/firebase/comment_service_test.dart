import 'package:app/middleware/api/comment_api.dart';
import 'package:app/middleware/firebase/comment_service.dart';
import 'package:app/middleware/models/comment.dart';
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
        'addComment given a map, collection and document reference adds a new comment with the given data',
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

  group('get comments', () {
    test(
        'getComments given a collection and document reference return all comments',
        () async {
      var comment1 = {'comment': 'hello'};
      var comment2 = {'comment': 'goodbye'};
      _firestore
          .collection('calendarEvent')
          .doc(docID)
          .collection('comments')
          .add(comment1);
      _firestore
          .collection('calendarEvent')
          .doc(docID)
          .collection('comments')
          .add(comment2);

      var list =
          await _commentService.getComments(DBCollection.Calendar, docID);

      expect(list.length, 2);
      expect(list.first['comment'], 'hello');
      expect(list.last['comment'], 'goodbye');
    });
  });

  group('delete comments', () {
    test(
        'deleteComment given comment id, collection and document reference delete the comment',
        () async {
      final comment = Comment(comment: 'hello');
      var store = _firestore
          .collection('calendarEvent')
          .doc(docID)
          .collection('comments');
      await store.add(comment.toMap());
      var snaps = await store.get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      comment.id = snaps.docs.first.id;

      await _commentService.deleteComment(
          comment.id, DBCollection.Calendar, docID);

      var snapshot = await _firestore
          .collection('calendarEvent')
          .doc(docID)
          .collection('comments')
          .get();
      var size = snapshot.docs.toList().length;

      expect(size, 0);
    });
  });

  group('update comment', () {
    test(
        'updateComment given collection, document reference, comment id and date updates the comment with the given data',
        () async {
      final comment = Comment(comment: 'hello');
      var store = _firestore
          .collection('calendarEvent')
          .doc(docID)
          .collection('comments');
      await store.add(comment.toMap());
      var snaps = await store.get();
      store.doc(snaps.docs.first.id).update({'id': snaps.docs.first.id});
      comment.id = snaps.docs.first.id;

      Map<String, dynamic> map = {'comment': 'comment updated'};

      await _commentService.updateComment(
          DBCollection.Calendar, docID, comment.id, map);

      var doc = await _firestore
          .collection('calendarEvent')
          .doc(docID)
          .collection('comments')
          .doc(comment.id)
          .get();

      expect(doc.data()['comment'], 'comment updated');
    });
  });
}
