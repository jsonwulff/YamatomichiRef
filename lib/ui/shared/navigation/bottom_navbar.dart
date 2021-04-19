import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

// TODO : replace BottomNavigationBar with this custom widget
class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key key, List<IconButton> items, this.onTap, this.icon})
      : super(key: key);

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
            icon: Icon(Icons.calendar_today,
                color: Colors.white, key: Key('BottomNavBar_1Icon')),
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
              Navigator.pushNamedAndRemoveUntil(context, personalProfileRoute,
                  (Route<dynamic> route) => false);
            },
          ),
          label: texts.gearReview,
        ),
      ],
    );

  }
}
