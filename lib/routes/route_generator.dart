import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/view/home.dart';
import 'package:app/ui/view/auth/sign_in.dart';
import 'package:app/ui/view/auth/sign_up.dart';
import 'package:app/ui/view/profile/edit_profile.dart';
import 'package:app/ui/view/profile/profile.dart';
import 'package:app/ui/view/unknown.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpView());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => SignInView());
      case editProfileRoute:
        return MaterialPageRoute(builder: (_) => EditProfileView());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfileView());
      case unknownRoute:
        return MaterialPageRoute(builder: (_) => UnknownPage());
      default:
        // If there is no such named route in the switch statemen
        return MaterialPageRoute(builder: (_) => UnknownPage());
    }
  }
}
