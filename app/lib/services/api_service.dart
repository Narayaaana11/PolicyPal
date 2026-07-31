import 'dart:convert';
import 'dart:io';
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

  /// Real-Time AI Agent chat with Base64 Multimodal Vision support
  static Future<dynamic> sendAgentChat({
    required String message,
    String? imageBase64,
    List<dynamic>? conversationHistory,
  }) async {
    return await post('/agent/chat', {
      'message': message,
      if (imageBase64 != null) 'image': imageBase64,
      if (conversationHistory != null) 'conversationHistory': conversationHistory,
    });
  }

  /// Get Proactive AI Insights for Dashboard
  static Future<dynamic> fetchProactiveInsights() async {
    return await get('/agent/insights');
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

  // ── PDF Upload — AI Policy Understanding ─────────────────
  
  /// Upload a policy PDF file for AI to parse and understand
  /// Returns the created policy along with AI analysis data
  static Future<dynamic> uploadPolicyPDF(File pdfFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final uri = Uri.parse('$baseUrl/policies/upload-pdf');
    final request = http.MultipartRequest('POST', uri);

    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'policyDocument',
        pdfFile.path,
        filename: pdfFile.path.split('/').last,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _processResponse(response);
  }

  // ── Notifications ────────────────────────────────────────
  static Future<dynamic> getNotifications() async {
    return await get('/notifications');
  }

  static Future<dynamic> markNotificationRead(String notificationId) async {
    return await patch('/notifications/$notificationId/read');
  }

  static Future<dynamic> clearAllNotifications() async {
    return await delete('/notifications/clear-all');
  }

  // ── Payments ─────────────────────────────────────────────
  static Future<dynamic> getUpcomingPayments() async {
    return await get('/payments/upcoming');
  }

  // ── Dashboard ────────────────────────────────────────────
  static Future<dynamic> getDashboardStats() async {
    return await get('/dashboard/stats');
  }

  // ── Auth — Password Change ──────────────────────────────
  static Future<dynamic> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await put('/auth/change-password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // ── Catalog ──────────────────────────────────────────────
  static Future<List<dynamic>> fetchPolicyCatalog([String search = '']) async {
    final query = search.isNotEmpty ? '?search=${Uri.encodeComponent(search)}' : '';
    final response = await get('/policies/catalog$query');
    if (response != null && response['data'] != null) {
      return response['data'] as List<dynamic>;
    }
    return [];
  }
}
