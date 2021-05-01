import 'dart:convert';
import 'package:http/http.dart' as http;

// https://hackernoon.com/7-steps-to-build-an-android-and-ios-app-for-your-wordpress-blog-via-flutter-2o4w336p
Future<List> fetchWpNews() async {
  final response = await http.get(
      Uri.parse("https://flutternerd.com/index.php/wp-json/wp/v2/posts"),
      headers: {"Accept": "application/json"});
  var convertDatatoJson = jsonDecode(response.body);
  return convertDatatoJson;
}
