import 'package:app/ui/routes/routes.dart';
import 'package:flutter/material.dart';

// TODO : replace BottomNavigationBar with this custom widget
class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key key, List<IconButton> items, this.onTap, this.icon}) : super(key: key);

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
            key: Key('BottomNavBar_1'),
            icon: Icon(Icons.calendar_today, color: Colors.white, key: Key('BottomNavBar_1Icon')),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, calendarRoute, (Route<dynamic> route) => false);
            },
          ),
          IconButton(
            key: Key('BottomNavBar_2'),
            icon: Icon(Icons.group, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, groupsRoute);
            },
          ),
          IconButton(
            key: Key('BottomNavBar_3'),
            icon: Icon(Icons.directions_walk_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, gearRoute);
            },
          ),
          IconButton(
            key: Key('BottomNavBar_4'),
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, profileRoute, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
