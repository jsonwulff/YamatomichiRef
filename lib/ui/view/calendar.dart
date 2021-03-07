import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart' as dateTimeline;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dtp;
import 'package:app/ui/components/event_widget.dart';
import 'package:app/middleware/firebase/database_service.dart';
import 'package:flutter/scheduler.dart';

class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DatabaseService db = DatabaseService();
  var events = List<EventWidget>();
  var eventNameController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  DateTime fromDate;
  DateTime toDate;
  String fromPlaceholder;
  String toPlaceholder;

  /* void createCard() {
    setState(() {
      var card = new EventWidget(
        title: eventNameController.text,
        description: eventDescriptionController.text,
        fromDate: fromDate,
        toDate: toDate,
      );
      cards.add(card);
    });
    eventNameController.clear();
    eventDescriptionController.clear();
    fromDate = null;
    toDate = null;
    Navigator.of(context).pop();
  } */

  //db.addEvent(data);

  void fromDatePicker() {
    showDateTimePicker(fromDate);
  }

  void toDatePicker() {
    showDateTimePicker(null);
  }

  void showDateTimePicker(DateTime from) {
    dtp.DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2022, 12, 31, 23, 59),
        theme: dtp.DatePickerTheme(
            headerColor: Colors.blue,
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16),
            cancelStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onConfirm: (date) {
      (from == fromDate) ? fromDate = date : toDate = date;
    }, currentTime: DateTime.now(), locale: dtp.LocaleType.en);
  }

  void showPopUp() {
    setState(() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Create new event'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: TextField(
                        controller: eventNameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          hintText: 'Enter event name',
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: TextField(
                        controller: eventDescriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          hintText: 'Enter event description',
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: fromDatePicker,
                          child: Text('Pick from date')),
                      TextButton(
                          onPressed: toDatePicker, child: Text('Pick to date'))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: FloatingActionButton(
                          onPressed: saveToDatabase,
                          child: Icon(Icons.add),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: FloatingActionButton(
                          onPressed: null,
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
    });
  }

  void popUpEnd() {
    Navigator.of(context).pop();
    eventNameController.clear();
    eventDescriptionController.clear();
    fromDate = null;
    toDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Column(
        children: [
          dateTimeline.DatePicker(DateTime.now(),
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.black,
              selectedTextColor: Colors.white, onDateChange: (date) {
            // New date selected
            /*setState(() {
              fromDate = date;
            });*/
          }),
          SingleChildScrollView(child: Column(children: makeChildren())),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPopUp,
        child: Icon(Icons.add),
      ),
    );
  }

  void saveToDatabase() {
    Map<String, dynamic> data = {
      'title': eventNameController.text,
      'description': eventDescriptionController.text,
      'fromDate': fromDate,
      'toDate': toDate
    };
    db.addEvent(data);
    popUpEnd();
  }

  void showEvents() {
    db.getEvents().then((a) => {
          events.clear(),
          a.forEach((element) => createEventWidget(element)),
          updateState()
        });
  }

  void updateState() {
    setState(() {});
  }

  void createEventWidget(Map<String, dynamic> data) {
    var eventWidget = EventWidget(
      title: data["title"],
      description: data["description"],
      fromDate: data["fromDate"].toDate(),
      toDate: data["toDate"].toDate(),
    );
    events.add(eventWidget);
  }

  List<EventWidget> makeChildren() {
    showEvents();
    return List.unmodifiable(() sync* {
      yield* events.toList();
    }());
  }
}
