import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserNames extends StatelessWidget {
  final UserProfile userProfile;
  final String labelTextFirstName;
  final String labelTextLastName;
  final Function(String) firstNameValidator;
  final Function(String) lastNameValidator;

  const UserNames(
    this.userProfile,
    this.labelTextFirstName,
    this.labelTextLastName,
    this.firstNameValidator,
    this.lastNameValidator, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              initialValue: userProfile.firstName ?? '',
              validator: (String value) => firstNameValidator(value),
              onSaved: (newValue) => userProfile.firstName = newValue,
              decoration: InputDecoration(
                labelText: labelTextFirstName,
              ),
              style: TextStyle(color: Color(0xff545871), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              initialValue: userProfile.lastName ?? '',
              validator: (String value) => lastNameValidator(value),
              onSaved: (newValue) => userProfile.lastName = newValue,
              decoration: InputDecoration(
                labelText: labelTextLastName,
              ),
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
