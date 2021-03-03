// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String id;
  // final db = FirebaseFirestore.instance;
  final _formKey = new GlobalKey<FormState>();
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Sign up'),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
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
                        onPressed: () {},
                        child: Text('Submit'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Read data'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      // body: SafeArea(
      //   minimum: const EdgeInsets.all(16),
      //   child: Center(
      //     child: Form(
      //         key: _formKey,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             TextFormField(
      //               decoration: const InputDecoration(labelText: 'Name'),
      //               onSaved: (String value) {
      //                 // Same save method
      //               },
      //               validator: (String value) {
      //                 return value.isEmpty ? 'Please fill out name' : null;
      //               },
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 createData();
      //               },
      //               child: Text("Update profile"),
      //             ),
      //           ],
      //         )),
      //   ),
      // ),
    );
  }

  void createData() async {
    // Validate the form from the fields validator methods
    // if (_formKey.currentState.validate()) {
    //   // Calls the fields onSave method
    //   _formKey.currentState.save();
    //   DocumentReference ref =
    //       await db.collection('userProfiles').add({'name': '$_name'});
    //   setState(() => id = ref.id);
    //   print(ref.id);
    // }
    print('test');
  }

  void readData() async {
    // final userUID = firebaseUser.uid;
    // print(userUID);
    // Map<String, dynamic> data
    // DocumentSnapshot snapshot =
    //     await db.collection('userProfiles').where('UserUID', isEqualTo: userUID).get();
    // Map<String, dynamic> data = snapshot.data();
    // print(data['name']);
    print('test');
  }
}
