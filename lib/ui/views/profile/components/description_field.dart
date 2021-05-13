import 'package:app/middleware/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    Key key,
    @required this.userProfile,
  }) : super(key: key);

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texts.aboutMe),
          Card(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      minLines: 1,
                      maxLength: 500,
                      initialValue: userProfile.description ?? '',
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                          counterStyle: TextStyle(height: 0.7),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Tell something about yourself...'),
                      onSaved: (String value) {
                        userProfile.description = value;
                      },
                      // width: MediaQuery.of(context).size.width / 2.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
