import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import '../core/services/storage_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _redirectUrl;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get redirectUrl => _redirectUrl;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.role == 'admin';

  Future<bool> login(String email, String password) async {
    _setLoading(true);

    try {
      final response = await AuthService.login(email, password);

      if (response['success']) {
        final userData = response['data'];
        _user = User.fromJson(userData['user']);
        _redirectUrl = userData['redirect_url'];
        await StorageService.setAccessToken(userData['token']);
        await StorageService.setUserData(userData['user']);
        await StorageService.setLoggedIn(true);
        _clearError();
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    _setLoading(true);

    try {
      final response = await AuthService.register(userData);

      if (response['success']) {
        final data = response['data'];
        _user = User.fromJson(data['user']);
        await StorageService.setAccessToken(data['token']);
        await StorageService.setUserData(data['user']);
        await StorageService.setLoggedIn(true);
        _clearError();
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await AuthService.logout();
    } catch (e) {
      // Continue logout even if API call fails
    }

    await StorageService.clearAll();
    _user = null;
    _clearError();
    _setLoading(false);
  }

  Future<void> loadUser() async {
    final userData = await StorageService.getUserData();
    final isLoggedIn = await StorageService.isLoggedIn();

    if (userData != null && isLoggedIn) {
      _user = User.fromJson(userData);
      notifyListeners();
    }
  }

  // Get current user profile
  Future<void> getCurrentUser() async {
    try {
      _setLoading(true);
      _clearError();

      final response = await AuthService.getCurrentUser();

      if (response['success'] == true) {
        _user = User.fromJson(response['data']);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load user profile');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await AuthService.updateProfile(profileData);

      if (response['success'] == true) {
        // Update user data in memory
        _user = User.fromJson(response['data']['user']);

        // Update stored user data
        await StorageService.setUserData(response['data']['user']);

        notifyListeners();
        return true;
      }

      _setError(response['message'] ?? 'Failed to update profile');
      return false;
    } catch (e) {
      _setError('Network error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() => _clearError();

  // Get target route after login based on user role and redirect URL
  String getPostLoginRoute() {
    // Check if user is admin
    if (_user?.isAdmin == true) {
      return '/admin/dashboard';
    }

    // Check redirect URL from backend
    if (_redirectUrl != null && _redirectUrl!.isNotEmpty) {
      if (_redirectUrl!.contains('/admin')) {
        return '/admin/dashboard';
      }
    }

    // Default to home for regular users
    return '/home';
  }
}
