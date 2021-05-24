import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List> fetchWpNews() async {
  final response = await http.get(
      Uri.parse(
          "https://www.yamatomichi.com/en/wp-json/wp/v2/news?_embed=1&per_page=10&oauth_consumer_key=SJ4lS6PV4vKz&oauth_token=Own5mxlbxqkqH9JgFbZWhtJv&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1621848255&oauth_nonce=DcZ1mdGtdqU&oauth_version=1.0&oauth_signature=86kCcL2yp66kiEqVDQeXIm5TyYA="),
      headers: {"Accept": "application/json", "Cookie": "lang=en_US"});
  var convertDatatoJson = jsonDecode(response.body);
  return convertDatatoJson;
}
