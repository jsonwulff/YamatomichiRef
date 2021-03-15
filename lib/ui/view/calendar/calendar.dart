import 'package:app/middleware/firebase/authentication_validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart' as dateTimeline;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as dtp;
import 'package:app/ui/components/event_widget.dart';
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:app/ui/components/text_form_field_generator.dart';
import 'package:flutter/scheduler.dart';
import 'package:app/routes/routes.dart';

class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarService db = CalendarService();
  var events = List<EventWidget>();
  var eventNameController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  DateTime fromDate;
  DateTime toDate;
  DateTime selectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

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
    Navigator.of(context).fpop();
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
        minTime: DateTime(2021, 3, 6, 0, 0, 0),
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
                  TextInputFormFieldComponent(
                    eventNameController,
                    AuthenticationValidation.validateNotNull, //check dis pls
                    'Title',
                    iconData: Icons.title,
                  ),
                  TextInputFormFieldComponent(
                    eventDescriptionController,
                    AuthenticationValidation.validateNotNull, //check dis pls

                    'Description',
                    iconData: Icons.text_fields_rounded,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: fromDatePicker, //check dis pls
                          child: Text('Pick from date')),
                      TextButton(
                          onPressed: toDatePicker,
                          child: Text('Pick to date')) //check dis pls
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
            setState(() {
              selectedDate = date;
            });
          }),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: makeChildren(),
            ),
          )),
          /*ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: 530.0,
            ),
            child: new ListView(
              children: makeChildren(),
            ),
          )*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createEvent');
        },
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
    db.getEventsByDate(selectedDate).then((e) => {
          events.clear(),
          e.forEach((element) => createEventWidget(element)),
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
