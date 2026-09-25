import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiHelper {
  // 1. Private constructor (prevents external instantiation)
  ApiHelper._internal();

  // 2. Static final instance — created once
  static final ApiHelper _instance = ApiHelper._internal();

  // 3. Factory constructor — always returns the same instance
  factory ApiHelper() => _instance;

  final http.Client _client = http.Client();
  void dispose() => _client.close();

  Future<dynamic> getApi({required String url, Map<String, String>? mHeaders}) async {
    try {
      final response = await _client.get(Uri.parse(url), headers: mHeaders);
      return returnResponse(response);
    } on SocketException {
      throw Exception('No Internet Connection');
    }
  }

  dynamic returnResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    switch (response.statusCode) {
      case 400:
        throw Exception('Bad Request: ${response.body}');
      case 401:
      case 403:
        throw Exception('Unauthorized: ${response.body}');
      case 404:
        throw Exception('Not Found: ${response.body}');
      case 500:
      default:
        throw Exception('Error occurred with Status Code: ${response.statusCode}');
    }
  }
}
