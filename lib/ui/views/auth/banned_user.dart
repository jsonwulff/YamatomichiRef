import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/middleware/firebase/user_profile_service.dart';
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
    var _texts = AppLocalizations.of(context);
    var _firebaseUser = context.read<AuthenticationService>().user;
    var _userProfileService = context.read<UserProfileService>();

    _bannedUserAlertDialog() {
      return FutureBuilder(
        future: _userProfileService.getUserProfile(_firebaseUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AlertDialog(
              key: Key('BannedUserAlert'),
              title: Text(_texts.bannedTitle),
              content: Text(snapshot.data.bannedMessage),
              actions: [
                SimpleDialogOption(
                  onPressed: () async {
                    await context
                        .read<AuthenticationService>()
                        .forceSignOut(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, signInRoute, (Route<dynamic> route) => false);
                  },
                  child: Text(_texts.close),
                )
              ],
            );
          }
        },
      );
    }

    return Scaffold(
      body: _bannedUserAlertDialog(),
    );
  }
}
