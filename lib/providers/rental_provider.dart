import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/services/storage_service.dart';
import '../models/rental.dart';
import '../services/rental_service.dart';

class RentalProvider extends ChangeNotifier {
  List<Rental> _rentals = [];
  Rental? _selectedRental;
  bool _isLoading = false;
  String? _errorMessage;

  List<Rental> get rentals => _rentals;
  Rental? get selectedRental => _selectedRental;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> getRentals() async {
    _setLoading(true);
    try {
      // First, get local saved rentals with error handling
      List<Rental> localRentals = [];
      try {
        localRentals = await RentalService.getSavedRentals();
      } catch (localError) {
        print('Error loading local rentals: $localError');
        // Continue without local rentals
      }
      
      // Try to get rentals from API
      try {
        final response = await http.get(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.rentals}'),
          headers: await _getHeaders(),
        );

        final data = jsonDecode(response.body);
        print('🔍 Backend Response: $data'); // Debug: Full response

        if (data['success']) {
          final responseData = data['data'];
          print('🔍 Response Data: $responseData'); // Debug: Data object
          List<Rental> apiRentals = [];
          try {
            apiRentals = (responseData['data'] as List)
                .map((json) {
                  print('🔍 Individual Rental JSON: $json'); // Debug: Individual rental
                  return Rental.fromJson(json);
                })
                .toList();
          } catch (parseError) {
            print('Error parsing API rentals: $parseError');
            // Continue with empty API rentals
          }
          
          // Combine local and API rentals
          _rentals = [...localRentals, ...apiRentals];
        } else {
          // If API fails, use only local rentals
          _rentals = localRentals;
        }
      } catch (apiError) {
        // If API call fails, use only local rentals
        print('API call failed, using local rentals: $apiError');
        _rentals = localRentals;
      }
      
      // Sort by order date (newest first)
      _rentals.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      
      _clearError();
    } catch (e) {
      _setError('Failed to load rentals: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getRentalDetail(int rentalId) async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.rentals}/$rentalId'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _selectedRental = Rental.fromJson(data['data']);
        _clearError();
      } else {
        _setError(data['message']);
      }
    } catch (e) {
      _setError('Failed to load rental detail: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createRental(Map<String, dynamic> rentalData) async {
    _setLoading(true);
    try {
      print('=== BACKEND REQUEST DEBUG ===');
      print('URL: ${ApiConstants.baseUrl}${ApiConstants.rentals}');
      print('Headers: ${await _getHeaders()}');
      print('Body: ${jsonEncode(rentalData)}');
      
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.rentals}'),
        headers: await _getHeaders(),
        body: jsonEncode(rentalData),
      );

      print('=== BACKEND RESPONSE DEBUG ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          _selectedRental = Rental.fromJson(data['data']);
          await getRentals(); // Refresh list
          _clearError();
          print('✅ Rental created successfully');
          return true;
        } else {
          _setError(data['message'] ?? 'Unknown error from backend');
          print('❌ Backend returned success=false: ${data['message']}');
          return false;
        }
      } else {
        _setError('HTTP ${response.statusCode}: ${data['message'] ?? response.body}');
        print('❌ HTTP Error ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      _setError('Failed to create rental: $e');
      print('❌ Exception in createRental: $e');
      print('Stack trace: ${StackTrace.current}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelRental(int rentalId) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.rentals}/$rentalId/cancel',
        ),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        await getRentals(); // Refresh list
        _clearError();
        return true;
      } else {
        _setError(data['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to cancel rental: $e');
      return false;
    }
  }

  List<Rental> getRentalsByStatus(String status) {
    return _rentals.where((rental) => rental.rentalStatus == status).toList();
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
  void clearSelectedRental() {
    _selectedRental = null;
    notifyListeners();
  }
}
