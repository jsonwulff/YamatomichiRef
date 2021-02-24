import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("TODO: Implement"),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Go a page back"))
        ],
      ),
    ));
  }
}
