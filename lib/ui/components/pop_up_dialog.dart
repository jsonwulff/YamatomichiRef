import 'package:flutter/material.dart';

Future<bool> signOutDialog(BuildContext context) async {
  if (await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text('Are you sure you want to sign out?'),
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
