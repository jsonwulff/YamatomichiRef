import 'package:app/middleware/models/review.dart';
import 'package:app/middleware/notifiers/gearReview_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GearReviewControllers {
  BuildContext context;
  static bool updated = false;
  static var titleController = TextEditingController();
  static var categoryController = TextEditingController();
  static var priceController = TextEditingController();
  static var descriptionController = TextEditingController();

  GearReviewControllers(BuildContext context) {
    this.context = context;
    GearReviewNotifier gearReviewNotifier = Provider.of<GearReviewNotifier>(context, listen: false);
    if (!(gearReviewNotifier.review == null) && !updated) {
      Review review = Provider.of<GearReviewNotifier>(context, listen: false).review;
      titleController.text = review.title;
      categoryController.text = review.category;
      descriptionController.text = review.description;
      updated = true;
    }
  }

  formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}";
  }

  formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  static dispose() {
    titleController = TextEditingController();
    categoryController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
  }
}
