import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  @override
  EditProfileViewState createState() => EditProfileViewState();
}

class EditProfileViewState extends State<EditProfileView> {
  String _firstName, _lastName;
  String _gender = 'Male';
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final _formKey = new GlobalKey<FormState>();

    final _firstNameField = TextFormField(
      decoration: InputDecoration(labelText: 'First name:'),
      validator: (input) => input.isEmpty ? 'Please fill in name' : null,
      onSaved: (input) => _firstName = input,
    );

    final _lastNameField = TextFormField(
      decoration: InputDecoration(labelText: 'Last name:'),
      validator: (input) => input.isEmpty ? 'Please fill in name' : null,
      onSaved: (input) => _lastName = input,
    );

    final _emailField = TextFormField(
      enabled: false,
      initialValue: 'test@mail.dk',
    );

    void createData() async {
      // Validate the form from the fields validator methods
      if (_formKey.currentState.validate()) {
        // Calls the fields onSave method
        String userUID = context.read<AuthenticationService>().user.uid;
        _formKey.currentState.save();
        await db
            .collection('userProfiles')
            .doc(userUID)
            .update({'name': '$_firstName'}).then(
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
      print(userUID);
      DocumentSnapshot snapshot =
          await db.collection('userProfiles').doc(userUID).get();
      Map<String, dynamic> data = snapshot.data();
      print(data['UserUID']);
      print(data['name']);
      // print('test');
    }

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: _firstNameField,
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: _lastNameField,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: _emailField,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          isExpanded: true,
                          value: _gender,
                          onChanged: (String newValue) {
                            setState(() {
                              _gender = newValue;
                            });
                          },
                          items: <String>['Male', 'Female', 'Other']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
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
                      ),
                      InkWell(
                        child: Text(
                          "Change password",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () => Navigator.pushNamed(context, unknownRoute),
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
}
