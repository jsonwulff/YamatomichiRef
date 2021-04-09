import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/views/news/carousel.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart' as dateTimeline;
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/event_widget.dart'; // Use localization

class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarService db = CalendarService();
  var events = [];
  var eventNameController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  DateTime startDate;
  DateTime endDate;
  DateTime selectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

  /* void createCard() {
    setState(() {
      var card = new EventWidget(
        title: eventNameController.text,
        description: eventDescriptionController.text,
        startDate: startDate,
        endDate: endDate,
      );
      cards.add(card);
    });
    eventNameController.clear();
    eventDescriptionController.clear();
    startDate = null;
    endDate = null;
    Navigator.of(context).fpop();
  } */

  //db.addEvent(data);

  /*void fromDatePicker() {
    showDateTimePicker(startDate);
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
      (from == startDate) ? startDate = date : endDate = date;
    }, currentTime: DateTime.now(), locale: dtp.LocaleType.en);
  }*/

  /*void showPopUp() {
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
  }*/

  /*void popUpEnd() {
    Navigator.of(context).pop();
    eventNameController.clear();
    eventDescriptionController.clear();
    startDate = null;
    endDate = null;
  }*/

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBarCustom.basicAppBar(texts.calendarCAP),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(margin: EdgeInsets.all(8.0), child: Carousel()),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                child: dateTimeline.DatePicker(DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.black,
                    selectedTextColor: Colors.white, onDateChange: (date) {
                  // New date selected
                  setState(() {
                    selectedDate = date;
                  });
                }),
              ),
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  children: makeChildren(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createEvent');
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  void saveToDatabase() {
    // Map<String, dynamic> data = {
    //   'title': eventNameController.text,
    //   'description': eventDescriptionController.text,
    //   'startDate': startDate,
    //   'endDate': endDate
    // };
    // db.addNewEvent(data);
    // popUpEnd();
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
      id: data["id"],
      title: data["title"],
      description: data["description"],
      startDate: data["startDate"].toDate(),
      endDate: data["endDate"].toDate(),
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
