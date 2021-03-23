import 'package:app/models/event.dart';
import 'package:app/ui/components/calendar/create_event_stepper.dart';
import 'package:app/ui/components/calendar/event_controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEventView extends StatefulWidget {
  CreateEventView({Key key}) : super(key: key);

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  Event event;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Create new event'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              EventControllers.updated = false;
            },
          )),
      body: StepperWidget(),
    );
  }
}
