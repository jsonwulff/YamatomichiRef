import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/views/news/carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/views/calendar/calendar_temp_utils.dart' as tmp;
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

import 'components/event_widget.dart'; // Use localization

class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarService db = CalendarService();
  List<EventWidget> eventWidgets = [];
  Map<String, int> dates = {};
  DateTime startDate;
  DateTime endDate;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  ItemScrollController itemScrollController = ItemScrollController();
  DateTime dateNow = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

  @override
  void initState() {
    super.initState();

    //getEvents();
    setup();
    _selectedDay = _focusedDay;
    print('init state');
    Future.delayed(Duration(milliseconds: 500),
        () => _onDaySelected(_selectedDay, _focusedDay));
    /*SchedulerBinding.instance
        .addPostFrameCallback((_) => _onDaySelected(_selectedDay, _focusedDay));*/
  }

  jumpTo(int index) {
    itemScrollController.jumpTo(index: index);
  }

  setup() async {
    await getEvents().then;
  }

  getEvents() async {
    db.getEvents().then((e) => {
          eventWidgets.clear(),
          dates.clear(),
          e.forEach(
              (element) => {getDates(element), createEventWidget(element)}),
          updateState(),
        });
  }

  getDates(Map<String, dynamic> element) {
    eventWidgets.isEmpty
        ? dates.addAll({
            tmp.convertDateTimeDisplay(
                element['startDate'].toDate().toString()): 0
          })
        : tmp.convertDateTimeDisplay(eventWidgets.last.startDate.toString()) !=
                tmp.convertDateTimeDisplay(
                    element['startDate'].toDate().toString())
            ? dates.addAll({
                tmp.convertDateTimeDisplay(
                        element['startDate'].toDate().toString()):
                    eventWidgets.length
              })
            // ignore: unnecessary_statements
            : null;
  }

  //This function is only used to show the correct amount of dots on each day
  List<tmp.Event> _getEventsForDay(DateTime day) {
    day = DateTime.parse(day.toString().replaceAll('Z', ''));
    // Implementation example
    return tmp.kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
    dates.containsKey(tmp.convertDateTimeDisplay(selectedDay.toString()))
        ? jumpTo(dates[tmp.convertDateTimeDisplay(selectedDay.toString())])
        // ignore: unnecessary_statements
        : null;
  }

  @override
  Widget build(BuildContext context) {
    //var texts = AppLocalizations.of(context);
    //itemScrollController.jumpTo(index: 2);

    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SafeArea(
          child: Column(children: [
            Container(margin: EdgeInsets.all(8.0), child: Carousel()),
            Container(
                child: TableCalendar<tmp.Event>(
                    firstDay: tmp.kFirstDay,
                    lastDay: tmp.kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) {
                      return _getEventsForDay(day);
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      // Use `CalendarStyle` to customize the UI
                      outsideDaysVisible: true,
                    ),
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarBuilders:
                        CalendarBuilders(outsideBuilder: (context, day, _) {
                      final text = DateFormat.d().format(day);
                      return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.grey),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              text,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )),
                          ));
                    }, selectedBuilder: (context, day, _) {
                      final text = DateFormat.d().format(day);
                      return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              text,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            )),
                          ));
                    }, markerBuilder: (context, date, events) {
                      Widget child;
                      if (events.isNotEmpty) {
                        child = Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 3, color: Colors.blue),
                              ),
                            ));
                      }
                      return child;
                    }, todayBuilder: (context, day, _) {
                      final text = DateFormat.d().format(day);
                      return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.grey),
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              text,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            )),
                          ));
                    }, defaultBuilder: (context, day, _) {
                      final text = DateFormat.d().format(day);
                      return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.grey),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                              text,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            )),
                          ));
                    }))),
            const SizedBox(height: 1.0),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                  child: FloatingActionButton(
                      mini: true,
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/createEvent'),
                      child: Icon(
                        Icons.add,
                      ))),
              Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 25, 5),
                  child: FloatingActionButton(
                      heroTag: null,
                      mini: true,
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/filtersForEvent'),
                      child: Icon(
                        Icons.sort_outlined,
                      )))
            ]),
            Expanded(
                child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    itemCount: eventWidgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: eventWidgets[index],
                      );
                    }))
          ]),
        ));
  }

  void updateState() {
    //print(events.length);
    setState(() {});
    //print(events.length);
  }

  createEventWidget(Map<String, dynamic> data) {
    var eventWidget = EventWidget(
        id: data["id"],
        title: data["title"],
        createdBy: data['createdBy'],
        category: data["category"],
        country: data["country"],
        region: data["region"],
        maxParticipants: data['maxParticipants'],
        participants: data["participants"],
        description: data["description"],
        startDate: data["startDate"].toDate(),
        endDate: data["endDate"].toDate(),
        mainImage: data["mainImage"],
        highlighted: data["highlighted"]);

    eventWidgets.add(eventWidget);
  }

  /*List<DateTime> getDates() {
    db.getEvents().then((e) => {
          dates.clear(),
          e.forEach((element) =>
              dates.add(timestampToDateTime(element['startDate']))),
        });
    return dates;
  }*/

  DateTime timestampToDateTime(Timestamp t) {
    return t.toDate();
  }
}
