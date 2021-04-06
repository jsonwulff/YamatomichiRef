import 'package:app/ui/components/imageUpload/image_uploader.dart';
import 'package:app/ui/view/gearReview/create_gearReview.dart';
import 'package:app/ui/view/gearReview/gear_review.dart';
import 'package:app/ui/view/packlist/create_packlist.dart';
import 'package:app/ui/view/packlist/packlist.dart';
import 'package:app/ui/view/profile/change_password.dart';
import 'package:app/ui/view/calendar/event_page.dart';
import 'package:app/ui/view/support/support.dart';
import 'package:app/ui/view/terms.dart';
import 'package:flutter/material.dart';
import 'package:app/routes/routes.dart';
import 'package:app/ui/view/home.dart';
import 'package:app/ui/view/auth/sign_in.dart';
import 'package:app/ui/view/auth/sign_up.dart';
import 'package:app/ui/view/profile/profile.dart';
import 'package:app/ui/view/unknown.dart';
import 'package:app/ui/view/calendar/calendar.dart';
import 'package:app/ui/view/gear.dart';
import 'package:app/ui/view/groups.dart';
import 'package:app/ui/view/calendar/create_event.dart';

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
      case termsRoute:
        return MaterialPageRoute(builder: (_) => TermsView());
      case changePasswordRoute:
        return MaterialPageRoute(builder: (_) => ChangePasswordView());
      case gearRoute:
        return MaterialPageRoute(builder: (_) => GearView());
      case groupsRoute:
        return MaterialPageRoute(builder: (_) => GroupsView());
      case createEventRoute:
        return MaterialPageRoute(builder: (_) => CreateEventView());
      case eventRoute:
        return MaterialPageRoute(builder: (_) => EventView());
      case packlistRoute:
        return MaterialPageRoute(builder: (_) => PacklistView());
      case gearReviewRoute:
        return MaterialPageRoute(builder: (_) => GearReviewView());
      case createPacklistRoute:
        return MaterialPageRoute(builder: (_) => CreatePacklistView());
      case createGearReviewRoute:
        return MaterialPageRoute(builder: (_) => CreateGearReviewView());
      default:
        // If there is no such named route in the switch statement
        return MaterialPageRoute(builder: (_) => UnknownPage());
    }
  }
}
