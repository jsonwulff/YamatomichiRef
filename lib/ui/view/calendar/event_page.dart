import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Display a specific event

class EventView extends StatefulWidget {
  EventView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  Widget buildEventPicture() {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
    );
  }

  Widget buildTitleColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildJoinEventButton(),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Text(
            'Title',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: Text(
            'location: region/country',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: Text('start date/time -- end date/time',
              style: TextStyle(fontSize: 15)),
        ),
        Divider(
          color: Colors.grey,
          thickness: 2,
        )
        //Event title
      ],
    );
  }

  Widget buildJoinEventButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: ElevatedButton(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  'Join event',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0))))));
  }

  Widget buildInfoColumn() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.person_add_outlined)),
                Padding(padding: EdgeInsets.all(10), child: Text('Min/Max')),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.payment_outlined)),
                Padding(padding: EdgeInsets.all(10), child: Text('payment'))
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.add_location_outlined)),
                Padding(
                    padding: EdgeInsets.all(10), child: Text('meeting point'))
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.flag_outlined)),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('dissolution point'))
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        children: [buildEventPicture(), buildTitleColumn(), buildInfoColumn()],
      ),
    );
  }
}
