import 'package:app/middleware/api/event_api.dart';
import 'package:app/middleware/notifiers/event_notifier.dart';
import 'package:app/ui/views/calendar/components/material_custom.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventWidget extends StatelessWidget {
  EventWidget(
      {Key key,
      this.id,
      this.title,
      this.description,
      this.startDate,
      this.endDate})
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
    var _theme = Theme.of(context);

    return TextButton(
        child: MaterialCustom.standard(
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: InkWell(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Image.network(
                      'https://picsum.photos/250?image=9',
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ),
                  // TODO make text go ... when to long
                  Text(
                    title,
                    style: _theme.textTheme.headline2,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        //   Container(
        //     margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        //     width: MediaQuery.of(context).size.width / 5.5,
        //     height: 130,
        //     child: Card(
        //       elevation: 0.0,
        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             DateFormat('HH:mm').format(startDate),
        //             style: TextStyle(
        //               color: Colors.black,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 20.0,
        //             ),
        //           ),
        //           Text(
        //             DateFormat('dd-MM').format(endDate),
        //             style: TextStyle(color: Colors.grey),
        //           ),
        //           Text(
        //             DateFormat('HH:mm').format(endDate),
        //             style: TextStyle(color: Colors.grey),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        //   Container(
        //     width: 250,
        //     height: 130,
        //     child: Card(
        //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        //       color: Colors.blue,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Text(
        //             title,
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //               fontFamily: 'Helvetica Neue',
        //               fontSize: 20.0,
        //             ),
        //           ),
        //           Text(
        //             description,
        //             overflow: TextOverflow.ellipsis,
        //             style: TextStyle(
        //               color: Colors.white,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ]),
        onPressed: () {
          openEvent(context);
        });
  }
}
