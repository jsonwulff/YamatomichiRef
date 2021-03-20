//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:app/models/event.dart';
import 'package:provider/provider.dart';

class EventControllers {
  BuildContext context;
  static var titleController = TextEditingController();
  static var startDateController = TextEditingController();
  static var startTimeController = TextEditingController();
  static var endDateController = TextEditingController();
  static var endTimeController = TextEditingController();
  static var deadlineController = TextEditingController();
  static var categoryController = TextEditingController();
  static var meetingPointController = TextEditingController();
  static var dissolutionPointController = TextEditingController();
  static var minParController = TextEditingController();
  static var maxParController = TextEditingController();
  static var requirementsController = TextEditingController();
  static var equipmentController = TextEditingController();
  static var priceController = TextEditingController();
  static var paymentController = TextEditingController();
  static var descriptionController = TextEditingController();

  EventControllers(BuildContext context) {
    this.context = context;
    EventNotifier eventNotifier =
        Provider.of<EventNotifier>(context, listen: false);
    if (!(eventNotifier.event == null)) {
      Event event = Provider.of<EventNotifier>(context).event;
      titleController.text = event.title;
      categoryController.text = event.category;
      meetingPointController.text = event.meeting;
      dissolutionPointController.text = event.dissolution;
      minParController.text = event.minParticipants.toString();
      maxParController.text = event.maxParticipants.toString();
      requirementsController.text = event.requirements;
      equipmentController.text = event.equipment;
      priceController.text = event.price;
      paymentController.text = event.payment;
      descriptionController.text = event.description;
    }
  }

  static dispose() {
    titleController = TextEditingController();
    categoryController = TextEditingController();
    meetingPointController = TextEditingController();
    dissolutionPointController = TextEditingController();
    minParController = TextEditingController();
    maxParController = TextEditingController();
    requirementsController = TextEditingController();
    equipmentController = TextEditingController();
    priceController = TextEditingController();
    paymentController = TextEditingController();
    descriptionController = TextEditingController();
  }
}
