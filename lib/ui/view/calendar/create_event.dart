import 'package:app/ui/components/create_event_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEventView extends StatefulWidget {
  CreateEventView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  @override
  Widget build(BuildContext context) {
    return StepperWidget();
  }
}
