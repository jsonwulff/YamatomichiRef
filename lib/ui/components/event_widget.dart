import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventWidget extends StatelessWidget {
  EventWidget(
      {Key key, this.title, this.description, this.fromDate, this.toDate})
      : super(key: key);
  final String title;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;

  String formatDateTime(DateTime date) {
    if (date == null) return "";
    return DateFormat('dd-MM-yyyy - kk:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        width: 100,
        height: 130,
        child: Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('kk:mm').format(fromDate),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Text(
                DateFormat('dd-MM').format(toDate),
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                DateFormat('kk:mm').format(toDate),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      Container(
        width: 250,
        height: 130,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Helvetica Neue',
                  fontSize: 20.0,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              /*Text(
                formatDateTime(fromDate),
                style: TextStyle(color: Colors.white),
              ),
              Text(
                formatDateTime(toDate),
                style: TextStyle(color: Colors.white),
              )*/
            ],
          ),
        ),
      ),
    ]);
  }
}
