import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {
  static String get baseUrl => AppConstants.localApiBaseUrl;

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );

    return _processResponse(response);
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );

    return _processResponse(response);
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );

    return _processResponse(response);
  }

  static Future<dynamic> patch(String endpoint, [Map<String, dynamic>? data]) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: data != null ? jsonEncode(data) : null,
    );

    return _processResponse(response);
  }

  static Future<dynamic> delete(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );

    return _processResponse(response);
  }

  static dynamic _processResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message = body['message'] ?? 'API Request Failed (${response.statusCode})';
      throw Exception(message);
    }
  }

  // AI Helper APIs
  static Future<dynamic> explainClause(String clauseText) async {
    return await post('/ai/explain-clause', {'clauseText': clauseText});
  }

  static Future<dynamic> scanOCR(String text, String filename) async {
    return await post('/ai/scan-ocr', {'text': text, 'filename': filename});
  }

  static Future<dynamic> assessClaim({
    required String policyId,
    required String description,
    required String incidentDate,
  }) async {
    return await post('/claims', {
      'policyId': policyId,
      'description': description,
      'incidentDate': incidentDate,
      'photoUrls': [],
    });
  }

  static Future<dynamic> chatWithAI(String message) async {
    return await post('/ai/explain-clause', {
      'clauseText': message,
    });
  }
}
