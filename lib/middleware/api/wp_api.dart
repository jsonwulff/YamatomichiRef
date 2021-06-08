import 'dart:convert';
import 'dart:collection';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app/constants/constants.dart';

/// This Generates a valid OAuth 1.0 URL
/// if [isHttps] is true we just return the URL with
/// [consumerKey] and [consumerSecret] as query parameters
String _getOAuthURL(String requestMethod, String queryUrl) {
  // TODO: It is not secure to keep tokens and secrets here
  String consumerKey = "SJ4lS6PV4vKz";
  String consumerSecret = "Q9HI1Q50gzWbo7vwQrZQcx247406zN5tXMpeMrsUB6ZbVdBY";

  String token = "Own5mxlbxqkqH9JgFbZWhtJv";
  String accessTokenSecret = "7rS5A9eM4gv1tLR3NFaUf9z35G7nb2xfnYMZotaKVhByY5bu";

  String url = queryUrl;
  bool containsQueryParams = url.contains("?");

  Random rand = Random();
  List<int> codeUnits = List.generate(10, (index) {
    return rand.nextInt(26) + 97;
  });

  /// Random string uniquely generated to identify each signed request
  String nonce = String.fromCharCodes(codeUnits);

  /// The timestamp allows the Service Provider to only keep nonce values for a limited time
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  String parameters = "oauth_consumer_key=" +
      consumerKey +
      "&oauth_nonce=" +
      nonce +
      "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
      timestamp.toString() +
      "&oauth_token=" +
      token +
      "&oauth_version=1.0&";

  if (containsQueryParams == true) {
    parameters = parameters + url.split("?")[1];
  } else {
    parameters = parameters.substring(0, parameters.length - 1);
  }

  Map<dynamic, dynamic> params = Uri.splitQueryString(parameters);
  // Map<dynamic, dynamic> params = QueryString.parse(parameters);
  Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
  treeMap.addAll(params);

  String parameterString = "";

  for (var key in treeMap.keys) {
    parameterString = parameterString + Uri.encodeQueryComponent(key) + "=" + treeMap[key] + "&";
  }

  parameterString = parameterString.substring(0, parameterString.length - 1);

  String method = requestMethod;
  String baseString = method +
      "&" +
      Uri.encodeQueryComponent(containsQueryParams == true ? url.split("?")[0] : url) +
      "&" +
      Uri.encodeQueryComponent(parameterString);

  String signingKey = consumerSecret + "&" + accessTokenSecret;
  crypto.Hmac hmacSha1 = crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1

  /// The Signature is used by the server to verify the
  /// authenticity of the request and prevent unauthorized access.
  /// Here we use HMAC-SHA1 method.
  crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));

  String finalSignature = base64Encode(signature.bytes);

  String requestUrl = "";

  if (containsQueryParams == true) {
    requestUrl = url.split("?")[0] +
        "?" +
        parameterString +
        "&oauth_signature=" +
        Uri.encodeQueryComponent(finalSignature);
  } else {
    requestUrl = url +
        "?" +
        parameterString +
        "&oauth_signature=" +
        Uri.encodeQueryComponent(finalSignature);
  }
  return requestUrl;
}

Future fetchWooProducts() async {
  http.Response response = await http.get(
      Uri.parse(_getOAuthURL(
          "GET", 'https://www.yamatomichi.com/wp-json/wp/v2/news?_embed=1&per_page=10')),
      headers: {"Content-Type": "Application/json"});
  var convertDatatoJson = jsonDecode(response.body);
  return convertDatatoJson;
}

Future<List> fetchWpNews(BuildContext context) async {
  var countryCode = Localizations.localeOf(context).languageCode;

  switch (countryCode) {
    case languageCodeEnglish:
      return await fetchWpENNews();
    case languageCodeJapanese:
      return await fetchWpJANews();
    default:
      return await fetchWpENNews();
  }
}

Future<List> fetchWpJANews() async {
  http.Response response = await http.get(
      Uri.parse(_getOAuthURL(
          "GET", 'https://www.yamatomichi.com/wp-json/wp/v2/news?_embed=1&per_page=10')),
      headers: {"Content-Type": "Application/json"});
  var convertDatatoJson = jsonDecode(response.body);
  return convertDatatoJson;
}

Future<List> fetchWpENNews() async {
  http.Response response = await http.get(
      Uri.parse(_getOAuthURL(
          "GET", 'https://www.yamatomichi.com/en/wp-json/wp/v2/news?_embed=1&per_page=10')),
      headers: {"Content-Type": "Application/json"});
  var convertDatatoJson = jsonDecode(response.body);
  return convertDatatoJson;
}
