import 'package:app/views/support.dart';
import 'package:app/views/home.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => HomePage(),
  '/support': (BuildContext context) => SupportPage(),
};