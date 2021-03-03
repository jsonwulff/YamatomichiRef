import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _name;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Sign up'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name:'),
                        validator: (input) =>
                            input.isEmpty ? 'Please fill in name' : null,
                        onSaved: (input) => _name = input,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: createData,
                              child: Text('Submit'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: readData,
                              child: Text('Read data'),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createData() async {
    // Validate the form from the fields validator methods
    if (_formKey.currentState.validate()) {
      // Calls the fields onSave method
      String userUID = context.read<AuthenticationService>().user.uid;
      _formKey.currentState.save();
      await db
          .collection('userProfiles')
          .doc(userUID)
          .update({'name': '$_name'});
    }
  }

  void readData() async {
    String userUID = context.read<AuthenticationService>().user.uid;
    print(userUID);

    DocumentSnapshot snapshot =
        await db.collection('userProfiles').doc(userUID).get();
    Map<String, dynamic> data = snapshot.data();
    print(data['UserUID']);
    // print('test');
  }
}
