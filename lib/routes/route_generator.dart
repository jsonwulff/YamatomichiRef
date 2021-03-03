import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/view/home.dart';
import 'package:app/ui/view/auth/sign_in.dart';
import 'package:app/ui/view/auth/sign_up.dart';
import 'package:app/ui/view/profile/profile.dart';
import 'package:app/ui/view/profile/profile_new.dart';
import 'package:app/ui/view/unknown.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case signUpRoute:
        // // Example of passing data
        // // Validation of passed data - in this case a string
        // if(args is String) {
        //   return MaterialPageRoute(builder: (_) => HomeView(data: args));
        // }
        // // If args is not of the correct type, return an error page.
        // // Possibly throw an exceptoion while in development
        // return MaterialPageRoute(builder: (_) => UnknownPage());
        return MaterialPageRoute(builder: (_) => SignUpView());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => SignInView());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case profileNewRoute:
        return MaterialPageRoute(builder: (_) => ProfileNew());
      default:
        // If there is no such named route in the switch statemen
        return MaterialPageRoute(builder: (_) => UnknownPage());
    }
  }
}
