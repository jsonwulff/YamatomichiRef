import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/event.dart';
import 'package:app/middleware/notifiers/event_filter_notifier.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/shared/formatters/datetime_formatter.dart';
import 'package:app/ui/shared/navigation/bottom_navbar.dart';
import 'package:app/ui/views/news/carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/views/calendar/calendar_temp_utils.dart' as tmp;
import 'package:app/middleware/firebase/calendar_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

import 'components/event_widget.dart';
import 'components/filter_events.dart';
import 'components/load.dart'; // Use localization

class CalendarView extends StatefulWidget {
  CalendarView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarService db = CalendarService();
  Map<String, int> dates = {};
  List<Widget> eventWidgets = [];
  DateTime startDate;
  DateTime endDate;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  ItemScrollController itemScrollController = ItemScrollController();
  DateTime dateNow =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  EventFilterNotifier eventFilterNotifier;
  UserProfileNotifier userProfileNotifier;
  //List<Map<String, dynamic>> events = [];
  Widget calendar;
  int allEventsLength;
  int filteredEventsLength;
  String lastDate;

  @override
  void initState() {
    //getEvents();
    _selectedDay = _focusedDay;
    /*Future.delayed(Duration(milliseconds: 500),
        () => _onDaySelected(_selectedDay, _focusedDay));*/
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onDaySelected(_selectedDay, _focusedDay));
    setup();
  }

  jumpTo(int index) {
    itemScrollController.jumpTo(index: index);
  }

  setup() async {
    userProfileNotifier = Provider.of<UserProfileNotifier>(context, listen: false);
    if (userProfileNotifier.userProfile == null) {
      var tempUser = context.read<AuthenticationService>().user;
      if (tempUser != null) {
        String userUid = context.read<AuthenticationService>().user.uid;
        UserProfileService userProfileService = UserProfileService();
        await userProfileService.getUserProfileAsNotifier(userUid, userProfileNotifier);
      }
    }

    updateState();
  }

  Future<String> getEvents() async {
    List<Map<String, dynamic>> events = [];
    eventWidgets.clear();
    dates.clear();
    events = await db.getEvents();
    allEventsLength = events.length;
    events = await filterEvents(events, eventFilterNotifier, userProfileNotifier.userProfile.id);
    filteredEventsLength = events.length;
    tmp.getEvents(events);
    events.forEach((event) => {getDates(event), createEventWidget(event)});
    print(dates.toString());
    return 'Success';
  }

  getDates(Map<String, dynamic> element) {
    if (eventWidgets.isEmpty) {
      eventWidgets.add(dateDivider(element['startDate'].toDate()));
      dates.addAll({tmp.convertDateTimeDisplay(element['startDate'].toDate().toString()): 0});
    } else if (lastDate != tmp.convertDateTimeDisplay(element['startDate'].toDate().toString())) {
      eventWidgets.add(dateDivider(element['startDate'].toDate()));
      dates.addAll({
        tmp.convertDateTimeDisplay(element['startDate'].toDate().toString()):
            eventWidgets.length - 1
      });
    }
    lastDate = tmp.convertDateTimeDisplay(element['startDate'].toDate().toString());
  }

  Widget dateDivider(DateTime date) {
    return Row(children: [
      Expanded(child: Divider()),
      Text(DateFormat('dd-MM-yyyy').format(date)),
      Expanded(child: Divider()),
    ]);
  }

  //This function is only used to show the correct amount of dots on each day
  List<tmp.tmpEvent> _getEventsForDay(DateTime day) {
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

  Widget buildCalendar(BuildContext context) {
    return Column(
      children: [
        Container(
            child: TableCalendar<tmp.tmpEvent>(
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
                headerStyle: HeaderStyle(formatButtonShowsNext: false),
                calendarBuilders: CalendarBuilders(outsideBuilder: (context, day, _) {
                  final text = DateFormat.d().format(day);
                  return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(
                          text,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
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
                          style: TextStyle(color: Colors.white, fontSize: 13),
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
                            border: Border.all(width: 3, color: Colors.blue),
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
                          border: Border.all(width: 1.5, color: Colors.grey),
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(
                          text,
                          style: TextStyle(color: Colors.white, fontSize: 13),
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
                          border: Border.all(width: 1.5, color: Colors.grey),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(
                          text,
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        )),
                      ));
                }))),
        const SizedBox(height: 0.0),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          allEventsLength != null
              ? Text(filteredEventsLength.toString() + " / " + allEventsLength.toString())
              : Container(),
          Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
              child: FloatingActionButton(
                  mini: true,
                  onPressed: () => Navigator.of(context).pushNamed('/createEvent'),
                  child: Icon(
                    Icons.add,
                  ))),
          Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 25, 5),
              child: FloatingActionButton(
                  heroTag: null,
                  mini: true,
                  onPressed: () => Navigator.of(context)
                      .pushNamed('/filtersForEvent')
                      .then((value) => updateState()),
                  child: Icon(
                    Icons.sort_outlined,
                  )))
        ]),
        Expanded(
            child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemCount: eventWidgets.length,
                itemBuilder: (BuildContext context, int index) {
                  /*if (index > 0 &&
                      eventWidgets[index].startDate.day != eventWidgets[index - 1].startDate.day) {
                    return Row(children: [
                      Expanded(child: Divider()),
                      Text("OR"),
                      Expanded(child: Divider()),
                    ]);
                  }*/
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: eventWidgets[index],
                  );
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //var texts = AppLocalizations.of(context);
    //itemScrollController.jumpTo(index: 2);
    eventFilterNotifier = Provider.of<EventFilterNotifier>(context, listen: true);
    if (eventFilterNotifier == null ||
        userProfileNotifier == null ||
        userProfileNotifier.userProfile == null) {
      return Container();
    }

    return Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: SafeArea(
          child: Column(children: [
            Expanded(flex: 1, child: Container(child: Carousel())),
            Expanded(
              flex: 4,
              child: FutureBuilder(
                future: getEvents(),
                builder: (context, _events) {
                  switch (_events.connectionState) {
                    case ConnectionState.none:
                      return Text('Something went wrong');
                      break;
                    case ConnectionState.done:
                      if (_events.data == 'Success') {
                        calendar = buildCalendar(context);
                        return calendar;
                      } else {
                        return Text('No data');
                      }
                      break;
                    default:
                      if (calendar != null) return calendar;
                      return load();
                      break;
                  }
                },
              ),
            ),
          ]),
        ));
  }

  void updateState() {
    //print(events.length);
    setState(() {
      print('building');
    });
    //print(events.length);
  }

  createEventWidget(Map<String, dynamic> data) {
    var eventWidget = EventWidget(
      id: data["id"],
      title: data["title"],
      description: data["description"],
      startDate: data["startDate"].toDate(),
      endDate: data["endDate"].toDate(),
      mainImage: data["mainImage"],
    );
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
