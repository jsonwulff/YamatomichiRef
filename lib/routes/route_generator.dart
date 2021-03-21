import 'package:app/ui/view/support/support.dart';
import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/view/home.dart';
import 'package:app/ui/view/auth/sign_in.dart';
import 'package:app/ui/view/auth/sign_up.dart';
import 'package:app/ui/view/profile/profile.dart';
import 'package:app/ui/view/unknown.dart';
import 'package:app/ui/view/calendar.dart';
import 'package:app/ui/view/gear.dart';
import 'package:app/ui/view/groups.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpView());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => SignInView());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case unknownRoute:
        return MaterialPageRoute(builder: (_) => UnknownPage());
      case supportRoute:
        return MaterialPageRoute(builder: (_) => SupportView());
      case calendarRoute:
        return MaterialPageRoute(builder: (_) => CalendarView());
      case gearRoute:
        return MaterialPageRoute(builder: (_) => GearView());
      case groupsRoute:
        return MaterialPageRoute(builder: (_) => GroupsView());

      default:
        // If there is no such named route in the switch statement
        return MaterialPageRoute(builder: (_) => UnknownPage());
    }
  }
}
