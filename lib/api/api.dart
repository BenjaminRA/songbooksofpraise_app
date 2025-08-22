import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:songbooksofpraise_app/auth/AppTokenGenerator.dart';

class API {
  static const String baseUrl = 'http://localhost:5342/app';
  // static const String baseUrl = 'https://backend.songbooksofpraise.com/app';

  static String _authToken() {
    String secret = 'EYzSF!HVIUyBTUlAe79wOw1%LU\$\$X9mdDk6B^5WOv45#2c\$4*\$dNp!2Pzt6sr^B&';

    return AppTokenGenerator.encryptAppToken(
      appId: 'songbooksofpraise',
      appKey: '10ScMp1hWK0Wt^q3EiZctB63k!XHv7nPoNXnCvV7zlZqZtp6d8@X3XQpDfI02gkb',
      encryptionSecret: secret,
      expirationHours: 1,
    );
  }

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Token': _authToken(),
      };

  static Future<dynamic> get(String endpoint, {Map<String, String> headers = const {}}) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: {...API.headers, ...headers});

    if (response.headers['content-type']?.contains('application/json') ?? false) {
      return jsonDecode(response.body);
    } else {
      return response.body;
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {...API.headers, ...headers},
      body: body,
      encoding: encoding,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {...API.headers, ...headers},
      body: body,
      encoding: encoding,
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {...API.headers, ...headers},
      body: body,
      encoding: encoding,
    );
    return jsonDecode(response.body);
  }
}
