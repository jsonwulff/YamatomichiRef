import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';

// TODO : replace BottomNavigationBar with this custom widget
class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key key, List<IconButton> items, this.onTap, this.icon})
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
              Navigator.pushNamed(context, calendarRoute);
            },
          ),
          IconButton(
            icon: Icon(Icons.groups, color: Colors.white),
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
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, homeRoute);
            },
          ),
        ],
      ),
    );
  }
}
