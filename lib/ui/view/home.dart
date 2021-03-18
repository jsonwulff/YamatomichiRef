import 'dart:io';

import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // UserProfile _userProfile;

  // @override
  // void initState() {
  //   super.initState();
  //   print('Initializing state');
  //   UserProfileNotifier userProfileNotifier =
  //       Provider.of<UserProfileNotifier>(context, listen: false);
  //   if (userProfileNotifier.userProfile == null) {
  //     String userUid = context.read<AuthenticationService>().user.uid;
  //     getUserProfile(userUid, userProfileNotifier);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    var texts = AppLocalizations.of(context);
    var _userProfile = Provider.of<UserProfileNotifier>(context).userProfile;

    Widget bannedUserAlertDialog() {
      return AlertDialog(
        title: Text('Banned'),
        content: Text('Message'),
        actions: [
          SimpleDialogOption(
            onPressed: () async {
              await context.read<AuthenticationService>().forceSignOut(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, signInRoute, (Route<dynamic> route) => false);
            },
            child: Text('Close'),
          )
        ],
      );
    }

    if (_userProfile.isBanned) {
      return Scaffold(
        body: bannedUserAlertDialog(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(texts.home),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushNamed(context, homeRoute);
                },
              ),
              IconButton(
                icon: Icon(Icons.account_box),
                onPressed: () {
                  Navigator.pushNamed(context, profileRoute);
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(firebaseUser != null
                  ? firebaseUser.email
                  : texts.notSignedIn),
              ElevatedButton(
                onPressed: () async {
                  if (await context
                      .read<AuthenticationService>()
                      .signOut(context)) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, signInRoute, (Route<dynamic> route) => false);
                  }
                },
                child: Text(texts.signOut),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, profileRoute);
                },
                child: Text(texts.profile),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/support');
                },
                child: Text(texts.support),
                key: Key('SupportButton'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calendar');
                },
                child: Text(texts.calendar),
              ),
            ],
          ),
        ),
      );
    }
  }
}
