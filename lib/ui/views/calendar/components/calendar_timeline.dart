import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

class TimelineWidget extends StatefulWidget {
  const TimelineWidget(
      {Key key,
      @required this.onDateChanged,
      @required this.initialDate,
      @required this.finalDate,
      this.datesWithEvents})
      : super(key: key);

  //final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime initialDate;
  final DateTime finalDate;
  final List<DateTime> datesWithEvents;

  @override
  BlackoutDates createState() => BlackoutDates();
}

class BlackoutDates extends State<TimelineWidget> {
  DateTime selectedDate = DateTime.now(); // TO tracking date
  DateTime currentDate = DateTime.now();

  int currentDateSelectedIndex = 0; //For Horizontal Date

  final scrollDirection = Axis.horizontal;

  IndexedScrollController controller;

  List<String> listOfMonths = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];

  List<String> listOfDays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

  @override
  void initState() {
    super.initState();
    controller =
        IndexedScrollController(initialIndex: 0, keepScrollOffset: false);
  }

  _scrollToIndex() {
    controller.jumpToIndex(0);
    currentDateSelectedIndex = 0;
  }

  bool isInList(List<DateTime> list, DateTime date) {
    if (list != null) {
      for (DateTime item in list) {
        if (DateFormat('yMMMMd').format(item) ==
            DateFormat('yMMMMd').format(date)) {
          return true;
        }
      }
    }
    return false;
  }

  Widget getDot(int index, List<DateTime> list) {
    if (isInList(list, currentDate.add(Duration(days: index)))) {
      return Icon(
        Icons.circle,
        size: 10,
        color: currentDateSelectedIndex == index ? Colors.white : Colors.black,
      );
    } else {
      return SizedBox(
        height: 5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    _scrollToIndex();
                  },
                  child: Text(
                    'Go to current date',
                    style: TextStyle(color: Colors.black),
                  ))),
          //To show Calendar Widget
          Container(
              margin: EdgeInsets.fromLTRB(6, 2, 2, 2),
              height: 85,
              child: Container(
                  child: IndexedListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 10);
                },
                minItemCount: widget.initialDate.difference(currentDate).inDays,
                maxItemCount: widget.finalDate.difference(currentDate).inDays,
                //itemCount: 365,
                controller: controller,
                scrollDirection: scrollDirection,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentDateSelectedIndex = index;
                        selectedDate = currentDate.add(Duration(days: index));
                        selectedDate = DateTime(selectedDate.year,
                            selectedDate.month, selectedDate.day, 0, 0, 0);
                        widget.onDateChanged(selectedDate);
                        print(selectedDate);
                      });
                    },
                    child: Container(
                      height: 90,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          /*boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[400],
                                  offset: Offset(3, 3),
                                  blurRadius: 5)
                            ],*/
                          color: currentDateSelectedIndex == index
                              ? Colors.black
                              : Color(0xfafafa)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            listOfMonths[currentDate
                                        .add(Duration(days: index))
                                        .month -
                                    1]
                                .toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            currentDate
                                .add(Duration(days: index))
                                .day
                                .toString(),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            listOfDays[currentDate
                                        .add(Duration(days: index))
                                        .weekday -
                                    1]
                                .toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          getDot(index, widget.datesWithEvents)
                        ],
                      ),
                    ),
                  );
                },
              ))),
        ],
      ),
    );
  }
}
