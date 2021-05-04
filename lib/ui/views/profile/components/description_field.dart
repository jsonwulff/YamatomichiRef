import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    Key key,
    @required this.context,
    @required this.userProfile,
  }) : super(key: key);

  final BuildContext context;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    return Row(children: [
      Flexible(
        child: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          maxLength: 500,
          initialValue: userProfile.description ?? '',
          decoration: InputDecoration(
            labelText: texts.description,
          ),
          onSaved: (String value) {
            userProfile.description = value;
          },
          // width: MediaQuery.of(context).size.width / 2.6,
        ),
      ),
    ]);
  }
}
