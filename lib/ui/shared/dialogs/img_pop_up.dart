import 'dart:io';

import 'package:app/ui/views/calendar/components/create_event_stepper.dart';
import 'package:flutter/material.dart';

Future<String> imgChoiceDialog(BuildContext context, var url) async {
  String answer = 'skip';
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          //title: new Text(question),
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Container(
                    height: 300,
                    width: 300,
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: url is String
                              ? NetworkImage(url)
                              : FileImage(url),
                          fit: BoxFit.cover),
                      //NetworkImage(url), fit: BoxFit.cover),
                    ))),
            Column(
              children: [
                new SimpleDialogOption(
                  //key: Key('yes'),
                  child: new Text('Remove from event'),
                  onPressed: () {
                    answer = 'remove';
                    Navigator.pop(context, true);
                  },
                ),
                new SimpleDialogOption(
                  //key: Key('yes'),
                  child: new Text('Set image as main picture'),
                  onPressed: () {
                    answer = 'main';
                    Navigator.pop(context, true);
                  },
                ),
              ],
            )
          ],
        );
      });
  return answer;
}
