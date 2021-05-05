import 'package:app/middleware/models/packlist.dart';
import 'package:app/middleware/notifiers/packlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PacklistControllers {
  BuildContext context;
  static bool updated = false;
  static var titleController = TextEditingController();
  static var createdAtController = TextEditingController();
  static var updatedAtController = TextEditingController();
  static var tagController = TextEditingController();
  static var descriptionController = TextEditingController();
  static var amountOfDaysController = TextEditingController();
  static var seasonController = TextEditingController();

  //all da lists
  static var allowCommentsController = TextEditingController();
  //static var countryController = TextEditingController();
  //static var regionController = TextEditingController();
  //static var weightController = TextEditingController(); // TODO FIGURE OUT THIS

  PacklistControllers(BuildContext context) {
    //print('bool ' + updated.toString());
    this.context = context;
    PacklistNotifier packlistNotifier =
        Provider.of<PacklistNotifier>(context, listen: false);
    if (!(packlistNotifier.packlist == null) && !updated) {
      Packlist packlist =
          Provider.of<PacklistNotifier>(context, listen: false).packlist;
      titleController.text = packlist.title;
      createdAtController.text = formatDate(packlist.createdAt.toDate());
      updatedAtController.text = formatTime(packlist.updatedAt.toDate());
      tagController.text = packlist.tag;
      descriptionController.text = packlist.description;
      amountOfDaysController.text = packlist.amountOfDays;
      seasonController.text = packlist.season;
      //countryController.text = packlist.country; TODO NOT MADE??
      //regionController.text = packlist.region;
      allowCommentsController.text = packlist.allowComments.toString();
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
    createdAtController = TextEditingController();
    updatedAtController = TextEditingController();
    tagController = TextEditingController();
    descriptionController = TextEditingController();
    amountOfDaysController = TextEditingController();
    seasonController = TextEditingController();
    //countryController = TextEditingController();
    //regionController = TextEditingController();
    allowCommentsController = TextEditingController();
    //weightController = TextEditingController();
  }
}
