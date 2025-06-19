import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/services/storage_service.dart';
import '../models/review.dart';

class ReviewProvider extends ChangeNotifier {
  List<Review> _reviews = [];
  List<Review> _myReviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Review> get reviews => _reviews;
  List<Review> get myReviews => _myReviews;
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

  Future<void> getReviews({int? equipmentId}) async {
    _setLoading(true);
    try {
      final queryParams =
          equipmentId != null
              ? {'equipment_id': equipmentId.toString()}
              : <String, String>{};
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.reviews}',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: await _getHeaders());
      final data = jsonDecode(response.body);

      if (data['success']) {
        final responseData = data['data'];
        _reviews =
            (responseData['data'] as List)
                .map((json) => Review.fromJson(json))
                .toList();
        _clearError();
      } else {
        _setError(data['message']);
      }
    } catch (e) {
      _setError('Failed to load reviews: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getMyReviews() async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.myReviews}'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _myReviews =
            (data['data'] as List)
                .map((json) => Review.fromJson(json))
                .toList();
        _clearError();
      } else {
        _setError(data['message']);
      }
    } catch (e) {
      _setError('Failed to load my reviews: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> submitReview(Map<String, dynamic> reviewData) async {
    _setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reviews}'),
        headers: await _getHeaders(),
        body: jsonEncode(reviewData),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        await getMyReviews(); // Refresh my reviews
        _clearError();
        return true;
      } else {
        _setError(data['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to submit review: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateReview(
    int reviewId,
    Map<String, dynamic> updateData,
  ) async {
    _setLoading(true);
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reviews}/$reviewId'),
        headers: await _getHeaders(),
        body: jsonEncode(updateData),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        await getMyReviews(); // Refresh my reviews
        _clearError();
        return true;
      } else {
        _setError(data['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to update review: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteReview(int reviewId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reviews}/$reviewId'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _myReviews.removeWhere((review) => review.id == reviewId);
        notifyListeners();
        _clearError();
        return true;
      } else {
        _setError(data['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to delete review: $e');
      return false;
    }
  }

  double getAverageRating(int equipmentId) {
    final equipmentReviews =
        _reviews.where((review) => review.equipmentId == equipmentId).toList();
    if (equipmentReviews.isEmpty) return 0.0;

    final totalRating = equipmentReviews.fold(
      0,
      (sum, review) => sum + review.rating,
    );
    return totalRating / equipmentReviews.length;
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
}
