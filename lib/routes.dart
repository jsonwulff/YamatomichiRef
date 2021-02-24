import 'package:app/views/FAQ.dart';
import 'package:app/views/home.dart';
import 'package:flutter/cupertino.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => HomePage(),
  '/FAQ': (BuildContext context) => FAQPage(),
};