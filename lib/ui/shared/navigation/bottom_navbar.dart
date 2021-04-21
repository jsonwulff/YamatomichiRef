import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

// TODO : replace BottomNavigationBar with this custom widget
class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key key, List<IconButton> items, this.onTap, this.icon}) : super(key: key);

  final String icon;
  final dynamic onTap;

  @override
  Widget build(BuildContext context) {
    var texts = AppLocalizations.of(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            key: Key('BottomNavBar_1'),
            icon: Icon(Icons.calendar_today, color: Colors.white, key: Key('BottomNavBar_1Icon')),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, calendarRoute, (Route<dynamic> route) => false);
            },
          ),
          label: texts.calendar,
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            key: Key('BottomNavBar_2'),
            icon: Icon(Icons.backpack_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, packlistNewRoute, (Route<dynamic> route) => false);
            },
          ),
          label: texts.gearReview,
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            key: Key('BottomNavBar_3'),
            icon: Icon(Icons.perm_identity, color: Colors.white),
            onPressed: () {
              // UserProfileNotifier userProfileNotifier =
              //     Provider.of<UserProfileNotifier>(context, listen: false);
              // if (userProfileNotifier.userProfile != null) userProfileNotifier.userProfile = null;
              Navigator.pushNamedAndRemoveUntil(
                  context, personalProfileRoute, (Route<dynamic> route) => false);
            },
          ),
          label: texts.gearReview,
        ),
        /*BottomNavigationBarItem(
          label: texts.male, // TODO something else like menu
          icon: IconButton(
            key: Key('BottomNavBar_4'),
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                ),
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      // height: 330,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            texts.profile,
                            textAlign: TextAlign.center,
                          ),
                          // dense: true,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, profileRoute, (Route<dynamic> route) => false);
                            // Navigator.pushNamed(context, profileRoute);
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
                        Divider(
                          thickness: 1,
                          height: 5,
                        ),
                        ListTile(
                          title: Text(
                            texts.settings,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, settingsRoute); // TODO Settings route
                          },
                        ),
                        Divider(thickness: 1),
                        ListTile(
                          title: Text(
                            texts.signOut,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () async {
                            if (await context.read<AuthenticationService>().signOut(context)) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, signInRoute, (Route<dynamic> route) => false);
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
        ),*/
      ],
    );
  }
}
