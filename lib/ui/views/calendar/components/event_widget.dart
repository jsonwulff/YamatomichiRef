import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventWidget extends StatelessWidget {
  EventWidget({Key key, this.id, this.title, this.description, this.startDate, this.endDate})
      : super(key: key);
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  EventNotifier eventNotifier;

  String formatDateTime(DateTime date) {
    if (date == null) return "";
    return DateFormat('dd-MM-yyyy - kk:mm').format(date);
  }

  openEvent(BuildContext context) async {
    await getEvent(id, eventNotifier);
    Navigator.pushNamed(context, '/event');
  }

  @override
  Widget build(BuildContext context) {
    eventNotifier = Provider.of<EventNotifier>(context, listen: false);
    return TextButton(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            width: MediaQuery.of(context).size.width / 5.5,
            height: 130,
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('HH:mm').format(startDate),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    DateFormat('dd-MM').format(endDate),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    DateFormat('HH:mm').format(endDate),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        onPressed: () {
          openEvent(context);
        });
  }
}
