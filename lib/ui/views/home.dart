import 'package:app/middleware/api/user_profile_api.dart';
import 'package:app/middleware/firebase/authentication_service_firebase.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/notifiers/user_profile_notifier.dart';
import 'package:app/routes/routes.dart';
import 'package:app/notifiers/navigatiobar_notifier.dart';
import 'package:app/ui/view/calendar/calendar.dart';
import 'package:app/ui/view/packlist/packlist.dart';
import 'package:app/ui/view/profile/profile.dart';
import 'package:app/middleware/models/user_profile.dart';
import 'package:app/middleware/notifiers/user_profile_notifier.dart';
import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'gearReview/gear_review.dart'; // Use localization

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserProfile _userProfile;

  @override
  Widget build(BuildContext context) {
// outcomment
    var currentTab = [
      CalendarView(),
      PacklistView(),
      GearReviewView(),
      ProfileView()
    ]; // supportview is only temporary as the last element

    var provider = Provider.of<BottomNavigationBarProvider>(context);
    // end of outcomment

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
          // TODO: refactor with new backend structure
          try {
            getUserProfile(userUid, userProfileNotifier);
          } on NoSuchMethodError catch (_) {
            context.read<AuthenticationService>().forceSignOut(context);
            Navigator.pushNamedAndRemoveUntil(
                context, signInRoute, (Route<dynamic> route) => false);
          }
        }
      }

      // Loading screen
      return Scaffold(
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(
              value: 0.7,
            ),
          ),
        ),
      );
    } else if (_userProfile.isBanned == null) {
      context.read<AuthenticationService>().forceSignOut(context);
      Navigator.pushNamedAndRemoveUntil(context, signInRoute, (Route<dynamic> route) => false);
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
// outcomment
      return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: currentTab[provider.currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: provider.currentIndex,
            onTap: (index) {
              provider.currentIndex = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today, color: Colors.white),
                label: texts
                    .calendar, // must not be null, and 'title: ..' is deprecated
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.backpack_outlined, color: Colors.white),
                label: texts
                    .gearReview, // must not be null, and 'title: ..' is deprecated
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border, color: Colors.white),
                label: texts
                    .gearReview, // must not be null, and 'title: ..' is deprecated
              ),
              BottomNavigationBarItem(
                label: texts.male, // TODO something else like menu
                icon: IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                      ),
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            // height: 330,
                            children: <Widget>[
                              Divider(thickness: 1),
                              ListTile(
                                title: Text(
                                  texts.profile,
                                  textAlign: TextAlign.center,
                                ),
                                // dense: true,
                                onTap: () {
                                  Navigator.pushNamed(context, profileRoute);
                                },
                              ),
                              Divider(
                                thickness: 1,
                                height: 5,
                              ),
                              ListTile(
                                title: Text(
                                  texts.support,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, supportRoute);
                                },
                              ),
                              /*Divider(
                                thickness: 1,
                                height: 5,
                              ),
                              ListTile(
                                title: Text(
                                  texts.settings,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, supportRoute); // TODO Settings route
                                },
                              ),*/
                              Divider(thickness: 1),
                              ListTile(
                                title: Text(
                                  texts.signOut,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () async {
                                  if (await context
                                      .read<AuthenticationService>()
                                      .signOut(context)) {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        signInRoute,
                                        (Route<dynamic> route) => false);
                                  }
                                },
                              ),
                              Divider(thickness: 1),
                              ListTile(
                                title: Text(
                                  texts.close,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ));
// end of outcomment
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.pushReplacementNamed(context, calendarRoute);
        },
      );

      return Container();
    }
  }
}
