import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class BannedUserView extends StatefulWidget {
  @override
  _BannedUserViewState createState() => _BannedUserViewState();
}

class _BannedUserViewState extends State<BannedUserView> {
  @override
  Widget build(BuildContext context) {
  var texts = AppLocalizations.of(context);
  
  _bannedUserAlertDialog() {
      return AlertDialog(
        key: Key('BannedUserAlert'),
        title: Text(texts.bannedTitle),
        content: Text(context.read()<UserProfileService>().bannedMessage),
        actions: [
          SimpleDialogOption(
            onPressed: () async {
              await context.read<AuthenticationService>().forceSignOut(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, signInRoute, (Route<dynamic> route) => false);
            },
            child: Text(texts.close),
          )
        ],
      );
    }


    return Scaffold(
      body: _bannedUserAlertDialog(),
    );
  }
}

