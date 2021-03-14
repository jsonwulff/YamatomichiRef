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
  @override
  Widget build(BuildContext context) {}
}
