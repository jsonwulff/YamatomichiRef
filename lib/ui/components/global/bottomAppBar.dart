import 'package:app/routes/routes.dart';
import 'package:app/ui/view/calendar.dart';
import 'package:app/ui/view/gear.dart';
import 'package:app/ui/view/groups.dart';
import 'package:app/ui/view/home.dart';
import 'package:flutter/material.dart';

class BottomAppBarHej extends StatefulWidget {
  BottomAppBarHej({Key key, List<IconButton> items, this.onTap, this.icon})
      : super(key: key);

  @override
  _BottomAppBarHej createState() => _BottomAppBarHej();

  static int selectedIndex = 0;

  static List<Widget> widgetOptions = <Widget>[
    HomeView(),
    GearView(),
    GroupsView(),
    CalendarView(),
  ];

  final String icon;
  final dynamic onTap;
}

class _BottomAppBarHej extends State<BottomAppBarHej> {
  static List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    GearView(),
    GroupsView(),
    CalendarView(),
  ];

  int _selectedIndex = BottomAppBarHej.selectedIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      BottomAppBarHej.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, color: Colors.white)),
          BottomNavigationBarItem(
              icon: Icon(Icons.group, color: Colors.white)),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_walk, color: Colors.white)),
          BottomNavigationBarItem(icon: Icon(Icons.menu, color: Colors.white)),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );

    // return BottomAppBar(
    //   color: Colors.black,
    //   child: new Row(
    //     mainAxisSize: MainAxisSize.max,
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: <Widget>[
    //       IconButton(
    //         icon: Icon(Icons.calendar_today, color: Colors.white),
    //         onPressed: () {
    //           Navigator.pushNamed(context, calendarRoute);
    //         },
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.groups, color: Colors.white),
    //         onPressed: () {
    //           Navigator.pushNamed(context, groupsRoute);
    //         },
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.directions_walk_outlined, color: Colors.white),
    //         onPressed: () {
    //           Navigator.pushNamed(context, gearRoute);
    //         },
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.menu, color: Colors.white),
    //         onPressed: () {
    //           Navigator.pushNamed(context, homeRoute);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
