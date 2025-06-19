import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/services/storage_service.dart';
import '../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  List<EquipmentCategory> _categories = [];
  EquipmentCategory? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  List<EquipmentCategory> get categories => _categories;
  EquipmentCategory? get selectedCategory => _selectedCategory;
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

  Future<void> getCategories() async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _categories =
            (data['data'] as List)
                .map((json) => EquipmentCategory.fromJson(json))
                .toList();
        _clearError();
      } else {
        _setError(data['message']);
      }
    } catch (e) {
      _setError('Failed to load categories: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getCategoryDetail(int id) async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.categories}/$id'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _selectedCategory = EquipmentCategory.fromJson(data['data']);
        _clearError();
      } else {
        _setError(data['message']);
      }
    } catch (e) {
      _setError('Failed to load category detail: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<List<EquipmentSubCategory>> getSubCategories(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.categories}/$categoryId/sub-categories',
        ),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => EquipmentSubCategory.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  void selectCategory(EquipmentCategory category) {
    _selectedCategory = category;
    notifyListeners();
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
