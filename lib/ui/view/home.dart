import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/view/calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserProfile _userProfile;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);
    _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    // handeles banned users
    if (_userProfile == null) {
      UserProfileNotifier userProfileNotifier =
          Provider.of<UserProfileNotifier>(context, listen: false);
      if (userProfileNotifier.userProfile == null) {
        var tempUser = context.read<AuthenticationService>().user;
        if (tempUser != null) {
          String userUid = context.read<AuthenticationService>().user.uid;
          getUserProfile(userUid, userProfileNotifier);
        }
      }

      // Loading screen
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(texts.loading),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (_userProfile.isBanned == null) {
      context.read<AuthenticationService>().forceSignOut(context);
      Navigator.pushNamedAndRemoveUntil(
          context, signInRoute, (Route<dynamic> route) => false);
    }

    Widget bannedUserAlertDialog() {
      return AlertDialog(
        key: Key('BannedUserAlert'),
        title: Text(texts.bannedTitle),
        content: Text(_userProfile.bannedMessage),
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

    if (_userProfile.isBanned) {
      return Scaffold(
        body: bannedUserAlertDialog(),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CalendarView(),
            ),
          );
        },
      );
      
      return Container();
    }
  }
}
