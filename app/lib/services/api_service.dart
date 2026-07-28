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

  // ── AI Helpers ──────────────────────────────────────────
  
  /// Main insurance AI chat assistant — calls /api/ai/chat
  static Future<dynamic> chatWithAI(String message) async {
    return await post('/ai/chat', {'message': message});
  }

  /// Translate an insurance clause into plain English
  static Future<dynamic> explainClause(String clauseText) async {
    return await post('/ai/explain-clause', {'clauseText': clauseText});
  }

  /// OCR scan a policy document
  static Future<dynamic> scanOCR(String text, String filename) async {
    return await post('/ai/scan-ocr', {'text': text, 'filename': filename});
  }

  /// Pre-check a claim before submitting
  static Future<dynamic> preCheckClaim({
    required String description,
    String? policyId,
    String? incidentDate,
  }) async {
    return await post('/ai/assess-claim', {
      'description': description,
      if (policyId != null) 'policyId': policyId,
      'incidentDate': incidentDate ?? DateTime.now().toIso8601String(),
      'photoUrls': [],
    });
  }

  /// Submit a claim to the DB
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

  // ── Notifications ────────────────────────────────────────
  static Future<dynamic> getNotifications() async {
    return await get('/notifications');
  }

  // ── Payments ─────────────────────────────────────────────
  static Future<dynamic> getUpcomingPayments() async {
    return await get('/payments/upcoming');
  }
}

