import 'package:app/routes.dart';
import 'package:app/views/unknown.dart';
import 'package:flutter/material.dart';

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yamatomichi',
      initialRoute: '/',
      routes: routes,
      onUnknownRoute: (RouteSettings settigns) {
        return MaterialPageRoute(
          settings: settigns,
          builder: (BuildContext context) => UnknownPage(),
        );
      },
    );
  }
}

void main() => runApp(Main());