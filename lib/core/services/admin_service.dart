import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'storage_service.dart';

class AdminService {
  static Future<String?> _getToken() async {
    return await StorageService.getAccessToken();
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Dashboard
  static Future<Map<String, dynamic>> getDashboard({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final queryParams = <String, String>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final uri = Uri.parse('${ApiConstants.baseUrl}/admin/dashboard')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Chats Management
  static Future<Map<String, dynamic>> getChats({
    String? status,
    String? search,
    int page = 1,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final queryParams = <String, String>{'page': page.toString()};
      if (status != null) queryParams['status'] = status;
      if (search != null) queryParams['search'] = search;

      final uri = Uri.parse('${ApiConstants.baseUrl}/admin/chats')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
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
        Uri.parse('${ApiConstants.baseUrl}/admin/chats/$chatId/messages'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> sendChatReply(int chatId, String message) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/admin/chats/$chatId/messages'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'message': message}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> closeChat(int chatId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/admin/chats/$chatId/close'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Rental Management
  static Future<Map<String, dynamic>> getRentals({
    String? status,
    int page = 1,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final queryParams = <String, String>{'page': page.toString()};
      if (status != null) queryParams['status'] = status;

      final uri = Uri.parse('${ApiConstants.baseUrl}/admin/rentals')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateRentalStatus(int rentalId, String status) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/admin/rentals/$rentalId/status'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Payment Management
  static Future<Map<String, dynamic>> getPayments({
    String? status,
    int page = 1,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final queryParams = <String, String>{'page': page.toString()};
      if (status != null) queryParams['status'] = status;

      final uri = Uri.parse('${ApiConstants.baseUrl}/admin/payments')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> approvePayment(int paymentId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/admin/payments/$paymentId/approve'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> rejectPayment(int paymentId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/admin/payments/$paymentId/reject'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Reports
  static Future<Map<String, dynamic>> getRentalSummary({
    String? startDate,
    String? endDate,
    String? status,
    int page = 1,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final queryParams = <String, String>{'page': page.toString()};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (status != null) queryParams['status'] = status;

      final uri = Uri.parse('${ApiConstants.baseUrl}/admin/reports/rental-summary')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getPaymentSummary({
    String? startDate,
    String? endDate,
    String? status,
    String? paymentMethod,
    int page = 1,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final queryParams = <String, String>{'page': page.toString()};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (status != null) queryParams['status'] = status;
      if (paymentMethod != null) queryParams['payment_method'] = paymentMethod;

      final uri = Uri.parse('${ApiConstants.baseUrl}/admin/reports/payment-summary')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getEquipmentUtilization({
    String? startDate,
    String? endDate,
    int? categoryId,
    int page = 1,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {'success': false, 'message': 'No authentication token'};
      }

      final queryParams = <String, String>{'page': page.toString()};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (categoryId != null) queryParams['category_id'] = categoryId.toString();

      final uri = Uri.parse('${ApiConstants.baseUrl}/admin/reports/equipment-utilization')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
