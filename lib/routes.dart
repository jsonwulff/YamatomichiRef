import 'package:app/ui/views/home.dart';
import 'package:app/ui/views/support.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => HomePage(),
  '/support': (BuildContext context) => SupportPage(),
};