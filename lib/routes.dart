import 'package:app/ui/view/home.dart';
import 'package:app/ui/view/auth/sign_up.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => HomeView(),
  '/signup': (BuildContext context) => SignUpView(),
};
