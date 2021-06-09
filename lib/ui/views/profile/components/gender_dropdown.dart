import 'package:app/constants/genders.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class GenderDropDown extends StatelessWidget {
  const GenderDropDown({
    Key key,
    @required this.userProfile,
    this.validator,
    this.useProfileStyling = false,
  }) : super(key: key);

  final UserProfile userProfile;
  final Function(String) validator;
  final bool useProfileStyling;

  @override
  Widget build(BuildContext context) {
    AppLocalizations texts = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        onSaved: (String value) {
          userProfile.gender = getGenderIdFromString(context, value).toString();
        },
        validator: (String value) => validator(value),
        value: userProfile.gender != null
            ? getGenderTranslated(context, userProfile.gender)
            : null, // Intial value
        style: useProfileStyling
            ? TextStyle(color: Color(0xff545871), fontWeight: FontWeight.bold)
            : null,
        onChanged: (value) {},
        decoration: InputDecoration(labelText: texts.gender),
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Colors.grey,
        ),
        items: getGendersListTranslated(context).map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
