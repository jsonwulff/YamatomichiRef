import 'package:app/notifiers/navigatiobar_notifier.dart';
import 'package:app/ui/view/calendar/calendar.dart';
import 'package:app/ui/view/gear.dart';
import 'package:app/ui/view/groups.dart';
import 'package:app/ui/view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Use localization

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  var currentTab = [CalendarView(), GroupsView(), GearView(), ProfileView()]; // supportview is only temporary as the last element

  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<BottomNavigationBarProvider>(context);
    var texts = AppLocalizations.of(context);

    return Scaffold(
      body: currentTab[provider.currentIndex],
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
            label: texts.calendar,  // must not be null, and 'title: ..' is deprecated 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group, color: Colors.white),
            label: texts.groups,  // must not be null, and 'title: ..' is deprecated
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_outlined, color: Colors.white),
            label: texts.gearReview,  // must not be null, and 'title: ..' is deprecated
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: Colors.white),  // TODO : make IconButton instead for sidemenu
            label: texts.settings,  // must not be null, and 'title: ..' is deprecated
          ),
        ],
      ),
    );
  }
}
