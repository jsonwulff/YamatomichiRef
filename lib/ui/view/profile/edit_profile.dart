import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  @override
  EditProfileViewState createState() => EditProfileViewState();
}

class EditProfileViewState extends State<EditProfileView> {
  String _name;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Edit Profile'),
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
          .update({'name': '$_name'}).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User profile updated'),
          ),
        ),
      );
    }
  }

  void readData() async {
    String userUID = context.read<AuthenticationService>().user.uid;
    print("UserUID: " + userUID);

    DocumentSnapshot snapshot =
        await db.collection('userProfiles').doc(userUID).get();
    Map<String, dynamic> data = snapshot.data();
    if (data == null) {
      print("No data");
    } else {
      data['UserUID'] == null ? print("No UserUID") : print(data['UserUID']);
      data['name'] == null ? print("No name") : print(data['name']);
    }
  }
}
