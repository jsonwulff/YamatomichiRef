import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

class TimelineWidget extends StatefulWidget {
  const TimelineWidget({Key key, @required this.onDateChanged})
      : super(key: key);

  //final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  /*final TextEditingController mainController;
  final validator;
  final String labelText;
  final IconData iconData;
  final TextEditingController optionalController;
  final bool isTextObscured;
  final Key key;
  final double width;

  TextInputFormFieldComponent(
      this.mainController, this.validator, this.labelText, 
      {this.iconData,
      this.optionalController,
      this.isTextObscured = false,
      this.key,
      this.width});*/

  @override
  BlackoutDates createState() => BlackoutDates();
}

class BlackoutDates extends State<TimelineWidget> {
  DateTime selectedDate = DateTime.now(); // TO tracking date
  DateTime currentDate = DateTime.now();

  int currentDateSelectedIndex = 0; //For Horizontal Date
  /*ScrollController scrollController =
      ScrollController();*/ //To Track Scroll of ListView
  final scrollDirection = Axis.horizontal;

  //utoScrollController controller;
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
    controller = IndexedScrollController(initialIndex: 0);
  }

  _scrollToIndex() {
    controller.jumpToIndex(0);
    currentDateSelectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
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
              height: 90,
              child: Container(
                  child: IndexedListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 10);
                },
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
                      height: 80,
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
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: currentDateSelectedIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ))),
        ],
      ),
    ));

    /*return SafeArea(
        child: Scaffold(
      body: Column(
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
              height: 100,
              child: Container(
                  child: ListView(
                      controller: controller,
                      scrollDirection: scrollDirection,
                      children: List.generate(widget.itemCount, (index) {
                        return AutoScrollTag(
                            key: ValueKey(index),
                            controller: controller,
                            index: index,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    currentDateSelectedIndex = index;
                                    selectedDate = widget.startDate
                                        .add(Duration(days: index));
                                    print(selectedDate);
                                  });
                                },
                                child: Container(
                                    height: 80,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            listOfMonths[widget.startDate
                                                        .add(Duration(
                                                            days: index))
                                                        .month -
                                                    1]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    currentDateSelectedIndex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            widget.startDate
                                                .add(Duration(days: index))
                                                .day
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    currentDateSelectedIndex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            listOfDays[widget.startDate
                                                        .add(Duration(
                                                            days: index))
                                                        .weekday -
                                                    1]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    currentDateSelectedIndex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            size: 10,
                                            color: currentDateSelectedIndex ==
                                                    index
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ]))));
                      })))),
        ],
      ),
    ));*/

    /*return SafeArea(
        child: Scaffold(
      body: Column(
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
              height: 80,
              child: Container(
                  child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 10);
                },
                itemCount: 365,
                controller: controller,
                scrollDirection: scrollDirection,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentDateSelectedIndex = index;
                        selectedDate =
                            widget.startDate.add(Duration(days: index));
                        print(selectedDate);
                      });
                    },
                    child: Container(
                      height: 80,
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
                            listOfMonths[widget.startDate
                                        .add(Duration(days: index))
                                        .month -
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
                          Text(
                            widget.startDate
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
                            height: 5,
                          ),
                          Text(
                            listOfDays[widget.startDate
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
                        ],
                      ),
                    ),
                  );
                },
              ))),
        ],
      ),
    ));*/
  }
}
