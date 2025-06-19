import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'storage_service.dart';

class AddressService {
  static Future<Map<String, dynamic>> getAddresses() async {
    try {
      final token = await StorageService.getAccessToken();
      
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addresses}'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Addresses Response Status: ${response.statusCode}');
      print('Get Addresses Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'] ?? 'Addresses retrieved successfully'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get addresses'
        };
      }
    } catch (e) {
      print('Get Addresses Error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> addAddress(Map<String, dynamic> addressData) async {
    try {
      final token = await StorageService.getAccessToken();
      
      print('Add Address Request URL: ${ApiConstants.baseUrl}${ApiConstants.addresses}');
      print('Add Address Request Body: ${jsonEncode(addressData)}');
      
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addresses}'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(addressData),
      );

      print('Add Address Response Status: ${response.statusCode}');
      print('Add Address Response Body: ${response.body}');

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'] ?? 'Address added successfully'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['errors']?.toString() ?? 'Failed to add address'
        };
      }
    } catch (e) {
      print('Add Address Error: $e');
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> updateAddress(int id, Map<String, dynamic> addressData) async {
    try {
      final token = await StorageService.getAccessToken();
      
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addressDetail(id)}'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(addressData),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'] ?? 'Address updated successfully'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update address'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> deleteAddress(int id) async {
    try {
      final token = await StorageService.getAccessToken();
      
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addressDetail(id)}'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Address deleted successfully'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete address'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }
}