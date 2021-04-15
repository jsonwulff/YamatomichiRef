import 'package:app/middleware/models/event.dart';
import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/views/calendar/components/calendar_timeline.dart';
import 'package:app/ui/views/news/carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart' as dateTimeline;
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

import 'components/event_widget.dart'; // Use localization

class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  ValueNotifier<List<Event>> _selectedEvents;
  CalendarService db = CalendarService();
  List<Event> events = [];
  List<DateTime> dates = [];
  var eventNameController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  DateTime startDate;
  DateTime endDate;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }
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
    something();

    return Scaffold(
        appBar: AppBarCustom.basicAppBar(texts.calendarCAP),
        body: Column(children: [
          Container(margin: EdgeInsets.all(8.0), child: Carousel()),
          TableCalendar(
            firstDay: DateTime(DateTime.now().year, DateTime.now().month - 3,
                DateTime.now().day),
            lastDay: DateTime(DateTime.now().year, DateTime.now().month + 3,
                DateTime.now().day),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            pageJumpingEnabled: true,
            startingDayOfWeek: StartingDayOfWeek.monday,
            //locale: 'ja',
            //eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          //const SizedBox(height: 8.0),
          /*Container(
            child: Column(children: something()),
          )*/
        ]));
  }
  /*return Scaffold(
      appBar: AppBarCustom.basicAppBar(texts.calendarCAP),
      body: SafeArea(
        child: Column(
          children: [
            Container(margin: EdgeInsets.all(8.0), child: Carousel()),
            TableCalendar(
              firstDay: DateTime(DateTime.now().year, DateTime.now().month - 3,
                  DateTime.now().day),
              lastDay: DateTime(DateTime.now().year, DateTime.now().month + 3,
                  DateTime.now().day),
              focusedDay: DateTime.now(),
              calendarFormat: _calendarFormat,
              locale: 'ja',
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),

            /*Expanded(
              flex: 3,
              child: TimelineWidget(
                datesWithEvents: getDates(),
                initialDate: DateTime.parse("2021-01-01 00:00:00"),
                finalDate: DateTime.parse("2021-06-01 00:00:00"),
                onDateChanged: (date) {
                  setState(() {
                    dateNow
               = date;
                  });
                },
              ),*/
            /*child: Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                child: dateTimeline.DatePicker(
                    DateTime.parse("2021-03-01 00:00:00"),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.black,
                    selectedTextColor: Colors.white,
                    //locale: "ja",
                    onDateChange: (date) {
                  // New date selected
                  setState(() {
                    dateNow
               = date;
                  });
                }),
              ),*/
            SingleChildScrollView(
              child: Column(
                children: makeChildren(),
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
  }*/

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

  List<Event> _getEventsForDay(DateTime day) {
    getEvents();
    return events ?? [];
  }

  List<EventWidget> something() {
    getEvents();
    //print(events.toString());
    List<EventWidget> eventWidgets = [];
    if (events.isNotEmpty) {
      for (Event event in events) {
        eventWidgets.add(createEventWidget(event.toMap()));
      }
    }
    //print(eventWidgets.toString());
    return eventWidgets;
  }

  void getEvents() {
    db.getEventsByDate(_selectedDay).then((e) => {
          events.clear(),
          e.forEach((element) => events.add(Event.fromMap(element))),
          updateState()
        });
  }

  void showEvents() {
    db.getEventsByDate(_selectedDay).then((e) => {
          events.clear(),
          e.forEach((element) => createEventWidget(element)),
          updateState()
        });
  }

  void updateState() {
    setState(() {});
  }

  EventWidget createEventWidget(Map<String, dynamic> data) {
    var eventWidget = EventWidget(
      id: data["id"],
      title: data["title"],
      description: data["description"],
      startDate: data["startDate"].toDate(),
      endDate: data["endDate"].toDate(),
    );
    return eventWidget;
    //events.add(eventWidget);
  }

  List<EventWidget> makeChildren() {
    showEvents();
    return List.unmodifiable(() sync* {
      yield* events.toList();
    }());
  }

  List<DateTime> getDates() {
    db.getEvents().then((e) => {
          dates.clear(),
          e.forEach((element) =>
              dates.add(timestampToDateTime(element['startDate']))),
        });
    return dates;
  }

  DateTime timestampToDateTime(Timestamp t) {
    return t.toDate();
  }
}
