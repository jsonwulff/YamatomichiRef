import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';

import 'fancy_fab.dart';

class BottomNavBarWithFAB extends StatelessWidget {
  BottomNavBarWithFAB(
      {Key key, List<BottomNavigationBarItem> items, this.onTap, this.icon})
      : super(key: key);

  final String icon;
  final dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, calendarRoute, (Route<dynamic> route) => false);
            },
          ),
          IconButton(
            icon: Icon(Icons.group, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, groupsRoute);
            },
          ),
          IconButton(
            icon: Icon(Icons.directions_walk_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, gearRoute);
            },
          ),
          FancyFab()
        ],
      ),
    );
  }
}
