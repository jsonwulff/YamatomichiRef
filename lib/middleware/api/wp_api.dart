import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchWpNews() async {
  final response = await http.get(
      Uri.parse("https://flutternerd.com/index.php/wp-json/wp/v2/posts"),
      headers: {"Accept": "application/json"});
  var convertDatatoJson = jsonDecode(response.body);
  return convertDatatoJson;
}
