import 'package:flutter/material.dart';

Future<bool> simpleChoiceDialog(BuildContext context, String question) async {
  if (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text(question),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            new SimpleDialogOption(
              child: new Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            )
          ],
        );
      })) {
    return true;
  } else {
    return false;
  }
}
