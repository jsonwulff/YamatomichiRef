import 'package:app/ui/routes/routes.dart';
import 'package:app/ui/views/auth/sign_in.dart';
import 'package:app/ui/views/auth/sign_up.dart';
import 'package:app/ui/views/calendar/calendar.dart';
import 'package:app/ui/views/calendar/calendar_temp.dart';
import 'package:app/ui/views/calendar/components/create_event_stepper.dart';
import 'package:app/ui/views/calendar/create_event.dart';
import 'package:app/ui/views/calendar/event_page.dart';
import 'package:app/ui/views/gearReview/create_gearReview.dart';
import 'package:app/ui/views/gearReview/gear_review.dart';
import 'package:app/ui/views/groups.dart';
import 'package:app/ui/views/home.dart';
import 'package:app/ui/views/packlist/create_packlist.dart';
import 'package:app/ui/views/packlist/packlist.dart';
import 'package:app/ui/views/profile/change_password.dart';
import 'package:app/ui/views/profile/profile.dart';
import 'package:app/ui/views/support/support.dart';
import 'package:app/ui/views/terms.dart';
import 'package:app/ui/views/unknown.dart';
import 'package:flutter/material.dart';

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
      case stepper:
        return MaterialPageRoute(builder: (_) => StepperWidget());
      default:
        // If there is no such named route in the switch statement
        return MaterialPageRoute(builder: (_) => UnknownPage());
    }
  }
}
