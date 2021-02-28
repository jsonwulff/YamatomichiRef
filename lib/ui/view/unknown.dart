import 'package:flutter/material.dart';

class UnknownPage extends StatefulWidget {
  @override
  _UnknownPageState createState() => _UnknownPageState();
}

class _UnknownPageState extends State<UnknownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text(
            'Couldn\'t find the given route',
          ),
          Text(
            '''
          Sorry the route you\'re trying to access is not avaible
          Please contact me if you've reached this page
          ''',
          ),
          FlatButton(
            child: Text('Go Back to the last page'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
    );
  }
}
