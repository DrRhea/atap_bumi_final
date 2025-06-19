import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class ChatService {
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<Map<String, dynamic>> getChats() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/chats'), // Remove /v1 since baseUrl already includes it
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      print('Chat Response: ${response.body}'); // Debug log
      return jsonDecode(response.body);
    } catch (e) {
      print('Chat Service Error: $e'); // Debug log
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getChatMessages(int chatId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/chats/$chatId/messages'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      print('Chat Messages Response: ${response.body}'); // Debug log
      return jsonDecode(response.body);
    } catch (e) {
      print('Chat Messages Error: $e'); // Debug log
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> createChat({
    required String subject,
    required String message,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/chats'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'subject': subject,
          'message': message,
        }),
      );

      print('Create Chat Response: ${response.body}'); // Debug log
      return jsonDecode(response.body);
    } catch (e) {
      print('Create Chat Error: $e'); // Debug log
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> sendMessage(int chatId, String message) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/chats/$chatId/messages'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': message,
        }),
      );

      print('Send Message Response: ${response.body}'); // Debug log
      return jsonDecode(response.body);
    } catch (e) {
      print('Send Message Error: $e'); // Debug log
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
