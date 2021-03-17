import 'package:app/middleware/api/event_api.dart';
import 'package:app/models/event.dart';
import 'package:intl/intl.dart';
import 'package:app/notifiers/event_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Display a specific event

class EventView extends StatefulWidget {
  EventView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  Widget buildEventPicture(String imageUrl) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
    );
  }

  _formatDateTime(DateTime dateTime) {
    return DateFormat('EE dd. MMMM y').format(dateTime);
  }

  Widget buildTitleColumn(Event event) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildJoinEventButton(event.id),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text(
            event.title,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: Text(
            '${event.region} / country',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: Text('placeholder', style: TextStyle(fontSize: 15)),
        ),
        Divider(
          color: Colors.grey,
          thickness: 2,
        )
        //Event title
      ],
    );
  }

  Widget buildJoinEventButton(String eventID) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: ElevatedButton(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  'Join event',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            onPressed: () {}, //check stream for participants
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0))))));
  }

  Widget buildInfoColumn(Event event) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.person)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        '${event.participants.length} / ${event.maxParticipants}')),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.payment_outlined)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Text('${event.price} '),
                      Text(
                        '( ${event.payment} )',
                        style: TextStyle(
                          color: Color.fromARGB(255, 169, 169, 169),
                        ),
                      )
                    ])),
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.location_on)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Expanded(
                        child: Text(
                            '${_formatDateTime(event.startDate.toDate())} / ${event.meeting}',
                            overflow: TextOverflow.ellipsis)))
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.flag)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        '${_formatDateTime(event.endDate.toDate())} / ${event.dissolution}',
                        overflow: TextOverflow.ellipsis))
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(10), child: Icon(Icons.flag)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        '${_formatDateTime(event.endDate.toDate())} / ${event.dissolution}',
                        overflow: TextOverflow.ellipsis))
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Event event = Provider.of<EventNotifier>(context, listen: true).event;
    return Scaffold(
      appBar: AppBar(
          title: Text('Event'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Column(
        children: [
          buildEventPicture(event.imageUrl),
          buildTitleColumn(event),
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: buildInfoColumn(event)))),
        ],
      ),
    );
  }
}
