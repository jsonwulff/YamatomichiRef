//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:app/models/event.dart';
import 'package:provider/provider.dart';

class EventControllers {
  BuildContext context;
  static EventControllers _instance;
  static bool updated = false;
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
    //print('bool ' + updated.toString());
    this.context = context;
    EventNotifier eventNotifier =
        Provider.of<EventNotifier>(context, listen: false);
    if (!(eventNotifier.event == null) && !updated) {
      Event event = Provider.of<EventNotifier>(context).event;
      print('date ' + event.startDate.toDate().toString());
      titleController.text = event.title;
      startDateController.text = formatDate(event.startDate.toDate());
      startTimeController.text = formatTime(event.startDate.toDate());
      endDateController.text = formatDate(event.endDate.toDate());
      endTimeController.text = formatTime(event.endDate.toDate());
      deadlineController.text = formatDate(event.deadline.toDate());
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
      updated = true;
    }
  }

  formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}";
  }

  formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  /*static EventControllers getInstance(BuildContext context) {
    if (_instance == null) _instance = EventControllers.internal(context);
    return _instance;
  }*/

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
