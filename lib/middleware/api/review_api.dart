import 'package:app/models/review.dart';
import 'package:app/notifiers/gearReview_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

addGearReviewToFirestore(Map<String, dynamic> data) async {
  Review newReview = Review();
  newReview.title = data['title'];
  newReview.createdBy = data['createdBy'];
  newReview.category = data['category'];
  newReview.description = data['description'];
  newReview.imageUrl = data['imageUrl'];
  newReview.createdAt = Timestamp.now();
  newReview.updatedAt = Timestamp.now();

  CollectionReference gearReviews =
      FirebaseFirestore.instance.collection('gearReview');

  DocumentReference ref = await gearReviews.add(newReview.toMap());
  await gearReviews.doc(ref.id).update({
    "id": ref.id,
  });
  return ref.id;
}

getReview(String reviewID, GearReviewNotifier gearReviewNotifier) async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('gearReview')
      .doc(reviewID)
      .get();
  Review review = Review.fromFirestore(snapshot);
  gearReviewNotifier.review = review;
  print('getReview called');
}

updateGearReview(
    Review review, Function gearReviewUpdated, Map<String, dynamic> map) async {
  CollectionReference reviewRef =
      FirebaseFirestore.instance.collection('gearReview');
  review.updatedAt = Timestamp.now();
  await reviewRef.doc(review.id).update(map);

  gearReviewUpdated(review);
  print('update review called');
}

delete(Review review) async {
  print('delete review begun');
  CollectionReference reviewRef =
      FirebaseFirestore.instance.collection('gearReview');
  await reviewRef.doc(review.id).delete().then((value) {
    print("review deleted");
  });
}

highlight(Review review) async {
  print('highlight review begun');
  CollectionReference reviewRef =
      FirebaseFirestore.instance.collection('gearReview');
  await reviewRef.doc(review.id).update({'highlighted': true}).then((value) {
    print('review highlighted');
    return true;
  });
}
