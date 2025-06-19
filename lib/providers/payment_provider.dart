import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/services/storage_service.dart';
import '../models/payment.dart';

class PaymentProvider extends ChangeNotifier {
  Payment? _payment;
  bool _isLoading = false;
  String? _errorMessage;

  Payment? get payment => _payment;
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

  Future<void> getPayment(int rentalId) async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.payments}/rental/$rentalId',
        ),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _payment =
            data['data']['payment'] != null
                ? Payment.fromJson(data['data']['payment'])
                : null;
        _clearError();
      } else {
        _setError(data['message']);
      }
    } catch (e) {
      _setError('Failed to load payment: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> submitPayment(Map<String, dynamic> paymentData) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.payments}'),
        headers: await _getHeaders(),
        body: jsonEncode(paymentData),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _payment = Payment.fromJson(data['data']);
        _clearError();
        return true;
      } else {
        _setError(data['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to submit payment: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePayment(
    int paymentId,
    Map<String, dynamic> updateData,
  ) async {
    _setLoading(true);
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.payments}/$paymentId'),
        headers: await _getHeaders(),
        body: jsonEncode(updateData),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _payment = Payment.fromJson(data['data']);
        _clearError();
        return true;
      } else {
        _setError(data['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to update payment: $e');
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
  void clearPayment() {
    _payment = null;
    notifyListeners();
  }
}
