import 'package:flutter/material.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/constants.dart';

class GenderDropDown extends StatelessWidget {
  const GenderDropDown({
    Key key,
    @required this.context,
    @required this.userProfile,
  }) : super(key: key);

  final BuildContext context;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text('Please select your gender'),
      onSaved: (String value) {
        userProfile.gender = value;
      },
      validator: (value) {
        if (value == null) {
          return 'Please provide your gender';
        }
        return null;
      },
      value: userProfile.gender, // Intial value
      onChanged: (value) {},
      items: gendersList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
