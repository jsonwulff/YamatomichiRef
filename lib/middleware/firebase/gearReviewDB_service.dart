import 'package:cloud_firestore/cloud_firestore.dart';

class GearReviewDBService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference gearReviews;

  GearReviewDBService() {
    gearReviews = db.collection('gearReviews');
  }

  Future<void> addReview(Map<String, dynamic> data) {
    if ((data['title'] ?? data['description'] == null))
      return throw Exception('Review not fulfilled correctly');

    return gearReviews.add({
      'title': data['title'],
      'description': data['description'],
    });
  }

  Future<List<Map<String, dynamic>>> getReviews() async {
    var snaps = await gearReviews.orderBy('fromDate').get();
    List<Map<String, dynamic>> reviews = [];
    snaps.docs.forEach((element) => reviews.add(element.data()));
    return reviews;
  }

  Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
    var snaps = await gearReviews
        .where('fromDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(date),
            isLessThan: Timestamp.fromDate(date.add(Duration(hours: 24))))
        .orderBy('fromDate')
        .get();
    List<Map<String, dynamic>> reviews = [];

    snaps.docs.forEach((element) => reviews.add(element.data()));
    return reviews;
  }

  Stream<QuerySnapshot> getStream() {
    return gearReviews.snapshots();
  }
}
