import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchWpNews() async {
  final response = await http.get(
      Uri.parse("https://www.yamatomichi.com/en/wp-json/wp/v2/news?per_page=10&_embed=1"),
      headers: {"Accept": "application/json"});
  var convertDatatoJson = jsonDecode(response.body);
  return convertDatatoJson;
}
