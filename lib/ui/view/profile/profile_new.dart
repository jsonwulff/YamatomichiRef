import 'package:flutter/material.dart';

class ProfileNew extends StatefulWidget {
  @override
  _ProfileNewState createState() => _ProfileNewState();
}

class _ProfileNewState extends State<ProfileNew> {
  String _name;

  @override
  Widget build(BuildContext context) {
    final formKeyy = new GlobalKey<FormState>();

    // String value = context.read<AuthenticationService>().user.uid;
    // print(value);
    return new Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Profile'),
      ),
      body: Form(
        key: formKeyy,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
