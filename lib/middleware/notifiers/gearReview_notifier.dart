import 'package:app/middleware/models/review.dart';
import 'package:flutter/material.dart';

class GearReviewNotifier with ChangeNotifier {
  Review _review;

  Review get review => _review;

  set review(Review review) {
    _review = review;
    print('Review set in notifier');
    notifyListeners();
  }

  remove() {
    _review = null;
    print('review removed from notifier');
  }
}
