import 'package:app/ui/shared/navigation/custom_nav_bar.dart';
import 'package:app/ui/views/calendar/calendar.dart';
import 'package:app/ui/views/packlist/packlist_new.dart';
import 'package:app/ui/views/personalProfile/personal_profile.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoggedInNavigationController extends StatefulWidget {
  @override
  _LoggedInNavigationControllerState createState() => _LoggedInNavigationControllerState();
}

class _LoggedInNavigationControllerState extends State<LoggedInNavigationController> {
  PersistentTabController _controller;
  bool _hideNavBar;
  AppLocalizations texts;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      CalendarView(title: 'Test title'),
      PacklistNewView(),
      PersonalProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today),
        title: texts.calendar,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.backpack_outlined),
        title: texts.packLists,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.perm_identity),
        title: texts.profile,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    texts = AppLocalizations.of(context);

    return Scaffold(
      body: PersistentTabView.custom(
        context,
        controller: _controller,
        screens: _buildScreens(),
        confineInSafeArea: true,
        itemCount: 3,
        stateManagement: true,
        hideNavigationBar: _hideNavBar,
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(microseconds: 5000),
        ),
        customWidget: CustomNavBarWidget(
          items: _navBarItems(),
          onItemSelected: (index) {
            setState(() {
              _controller.index = index;
            });
          },
          selectedIndex: _controller.index,
        ),
      ),
    );
  }
}
