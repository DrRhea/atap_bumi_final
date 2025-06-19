import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  static Future<String?> getToken() async {
    try {
      // Try StorageService first
      final token = await StorageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
      
      // Fallback to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  static Future<bool> saveToken(String token) async {
    try {
      // Save to both StorageService and SharedPreferences for redundancy
      await StorageService.setAccessToken(token);
      
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  static Future<bool> removeToken() async {
    try {
      // Clear from both storage methods
      await StorageService.clearAll();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      return true;
    } catch (e) {
      print('Error removing token: $e');
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Save token immediately after successful login
        if (data['data']?['token'] != null) {
          await saveToken(data['data']['token']);
        }
        
        return {
          'success': true,
          'data': data['data'],
          'message': data['message']
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: ApiConstants.defaultHeaders,
        body: jsonEncode(userData),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Save token immediately after successful registration
        if (data['data']?['token'] != null) {
          await saveToken(data['data']['token']);
        }
        
        return {
          'success': true,
          'data': data['data'],
          'message': data['message']
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await getToken();
      
      if (token != null) {
        final response = await http.post(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}'),
          headers: {
            ...ApiConstants.defaultHeaders,
            'Authorization': 'Bearer $token',
          },
        );

        // Always clear local storage regardless of API response
        await removeToken();

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'message': data['message'] ?? 'Logged out successfully'
          };
        }
      }
      
      // Clear local storage even if no token or API fails
      await removeToken();
      return {
        'success': true,
        'message': 'Logged out successfully'
      };
    } catch (e) {
      // Always clear local storage on logout, even if there's an error
      await removeToken();
      return {
        'success': true,
        'message': 'Logged out successfully'
      };
    }
  }

  // Get current user profile - dengan fallback untuk development
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getToken();
      
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No authentication token found. Please login again.'
        };
      }
      
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.me}'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message']
        };
      } else if (response.statusCode == 401) {
        // Token expired or invalid - clear local storage
        await removeToken();
        return {
          'success': false,
          'message': 'Session expired. Please login again.'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get user profile'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await getToken();
      
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'No authentication token found. Please login again.'
        };
      }
      
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.profile}'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message']
        };
      } else if (response.statusCode == 401) {
        // Token expired or invalid - clear local storage
        await removeToken();
        return {
          'success': false,
          'message': 'Session expired. Please login again.'
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update profile'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e'
      };
    }
  }

  // Create dummy token for development/testing
  static Future<void> createDummySession() async {
    const dummyToken = 'dummy_token_for_development';
    const dummyUser = {
      'id': '1',
      'full_name': 'Demo User',
      'email': 'demo@example.com',
      'phone_number': '+1234567890',
      'member_status': 'regular',
      'profile_photo': null,
    };
    
    await saveToken(dummyToken);
    await StorageService.setUserData(dummyUser);
    await StorageService.setLoggedIn(true);
  }
}
