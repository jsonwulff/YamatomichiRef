import 'package:app/middleware/api/review_api.dart';
import 'package:app/models/review.dart';
import 'package:app/notifiers/gearReview_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:app/ui/components/pop_up_dialog.dart';

class GearReviewService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference gearReviews;

  GearReviewService() {
    gearReviews = db.collection('gearReview');
  }

  Future<String> addNewGearReview(
      Map<String, dynamic> data, GearReviewNotifier gearReviewNotifier) async {
    var ref = await addGearReviewToFirestore(data);
    if (ref != null) await getReview(ref, gearReviewNotifier);
    return 'Success';
  }

  Future<List<Map<String, dynamic>>> getReviews() async {
    var snaps = await gearReviews.orderBy('startDate').get();
    List<Map<String, dynamic>> reviews = [];
    snaps.docs.forEach((element) => reviews.add(element.data()));
    return reviews;
  }

  Future<List<Map<String, dynamic>>> getReviewsByDate(DateTime date) async {
    var snaps = await gearReviews
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(date),
            isLessThan: Timestamp.fromDate(date.add(Duration(hours: 24))))
        .orderBy('date')
        .get();
    List<Map<String, dynamic>> reviews = [];

    snaps.docs.forEach((element) => reviews.add(element.data()));
    return reviews; // TODO THIS METHOD MIGHT NOT WORK SINCE I DONT HAVE START AND END DATE
  }

  /*Stream<int> getStreamOfParticipants() async* {
    Event event = Provider.of<EventNotifier>(context, listen: true).event
    return getEventParticipants(event.id);
  }*/

  Stream<QuerySnapshot> getStream() {
    return gearReviews.snapshots();
  }

  Future<void> makeReview(String reviewID) {
    return null;
  }

  Future<bool> deleteReview(BuildContext context, Review review) async {
    if (await simpleChoiceDialog(
        context, 'Are you sure you want to delete this review?')) {
      await delete(review);
      return true;
    }
    return false;
  }

  Future<bool> highlightGearReview(
      Review review, GearReviewNotifier gearReviewNotifier) async {
    print('highlight gearReview begun');
    CollectionReference gearReviewRef =
        FirebaseFirestore.instance.collection('gearReview');
    if (review.highlighted) {
      await gearReviewRef
          .doc(review.id)
          .update({'highlighted': false}).then((value) {
        getReview(review.id, gearReviewNotifier);
        print('review highlighted set to false');
        return true;
      });
    } else {
      await gearReviewRef
          .doc(review.id)
          .update({'highlighted': true}).then((value) {
        getReview(review.id, gearReviewNotifier);
        print('Review highlighted set to true');
        return true;
      });
    }
    return false;
  }
}
