import 'package:app/constants/constants.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';

class GenderDropDown extends StatelessWidget {
  const GenderDropDown({
    Key key,
    @required this.userProfile,
  }) : super(key: key);

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        hint: Text('Please select your gender'),
        onSaved: (String value) {
          userProfile.gender = value;
        },
        // TODO: Insert form field validator here
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
      ),
    );
  }
}
