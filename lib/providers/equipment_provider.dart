import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/services/storage_service.dart';
import '../models/equipment.dart';

class EquipmentProvider extends ChangeNotifier {
  List<Equipment> _equipments = [];
  Equipment? _selectedEquipment;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreData = true;

  List<Equipment> get equipments => _equipments;
  Equipment? get selectedEquipment => _selectedEquipment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;

  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> getEquipments({
    int? categoryId,
    int? subCategoryId,
    String? search,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _equipments.clear();
    }

    if (!_hasMoreData) return;

    _setLoading(true);
    try {
      final queryParams = <String, String>{
        'page': _currentPage.toString(),
        'per_page': '10',
      };
      if (categoryId != null)
        queryParams['category_id'] = categoryId.toString();
      if (subCategoryId != null)
        queryParams['sub_category_id'] = subCategoryId.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.equipment}',
      ).replace(queryParameters: queryParams);

      // Debug print untuk melihat URL dan parameter yang dikirim
      print('API Request URL: $uri');
      print('Query Parameters: $queryParams');

      final response = await http.get(uri, headers: await _getHeaders());
      final data = jsonDecode(response.body);

      // Debug print untuk melihat respons dari API
      print('API Response Status: ${response.statusCode}');
      print(
        'API Response Body (first 500 chars): ${response.body.length > 500 ? response.body.substring(0, 500) + "..." : response.body}',
      );
      if (response.statusCode == 200) {
        if (data['success']) {
          final responseData = data['data'];

          // Debug respons data structure
          print('Response data keys: ${responseData.keys}');
          print('Data array type: ${responseData['data'].runtimeType}');
          print('Data array length: ${responseData['data'].length}');
          final List<Equipment> allEquipments =
              (responseData['data'] as List)
                  .map((json) => Equipment.fromJson(json))
                  .toList(); // Apply manual price filter since backend doesn't seem to handle it properly
          List<Equipment> filteredEquipments = allEquipments;
          if (minPrice != null || maxPrice != null) {
            final double filterMinPrice = minPrice ?? 0;
            final double filterMaxPrice = maxPrice ?? double.infinity;

            filteredEquipments =
                allEquipments.where((equipment) {
                  final price = equipment.rentalPricePerDay;
                  return price >= filterMinPrice && price <= filterMaxPrice;
                }).toList();
            print('Manual filter applied:');
            print('- Original count: ${allEquipments.length}');
            print('- Filtered count: ${filteredEquipments.length}');
            print('- Price range: $filterMinPrice - $filterMaxPrice');
          } // Apply manual sorting since backend doesn't handle it properly
          if (sortBy != null && filteredEquipments.isNotEmpty) {
            print('Applying manual sorting: $sortBy');

            switch (sortBy) {
              case 'price_asc':
                filteredEquipments.sort(
                  (a, b) => a.rentalPricePerDay.compareTo(b.rentalPricePerDay),
                );
                print('Applied price_asc sorting');
                break;
              case 'price_desc':
                filteredEquipments.sort(
                  (a, b) => b.rentalPricePerDay.compareTo(a.rentalPricePerDay),
                );
                print('Applied price_desc sorting');
                break;
              case 'name':
                filteredEquipments.sort(
                  (a, b) => a.equipmentName.toLowerCase().compareTo(
                    b.equipmentName.toLowerCase(),
                  ),
                );
                print('Applied name sorting');
                break;
              case 'rating':
                filteredEquipments.sort((a, b) {
                  final aRating = a.averageRating ?? 0.0;
                  final bRating = b.averageRating ?? 0.0;
                  return bRating.compareTo(aRating);
                });
                print('Applied rating sorting');
                break;
            }

            print(
              'After sorting - prices: ${filteredEquipments.map((e) => e.rentalPricePerDay).take(5).join(', ')}',
            );
          }

          // Debug print untuk melihat produk yang dikembalikan
          print('Number of equipment returned: ${filteredEquipments.length}');
          if (filteredEquipments.isNotEmpty) {
            print('Sample equipment after sorting ($sortBy):');
            for (
              int i = 0;
              i <
                  (filteredEquipments.length > 5
                      ? 5
                      : filteredEquipments.length);
              i++
            ) {
              print(
                '- ${filteredEquipments[i].equipmentName}: Rp ${filteredEquipments[i].rentalPricePerDay}',
              );
            }
          }

          if (refresh) {
            _equipments = filteredEquipments;
          } else {
            _equipments.addAll(filteredEquipments);
          }

          _currentPage++;
          _hasMoreData =
              responseData['current_page'] < responseData['last_page'];
          _clearError();
        } else {
          _setError(data['message']);
        }
      } else {
        _setError('Failed to load equipment: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Failed to load equipment: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getEquipmentDetail(int id) async {
    _setLoading(true);
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.equipment}/$id'),
        headers: await _getHeaders(),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        _selectedEquipment = Equipment.fromJson(data['data']);
        _clearError();
      } else {
        _setError(data['message']);
      }
    } catch (e) {
      _setError('Failed to load equipment detail: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Equipment>> searchEquipment(String query) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.equipmentSearch}',
      ).replace(queryParameters: {'q': query});

      final response = await http.get(uri, headers: await _getHeaders());
      final data = jsonDecode(response.body);

      if (data['success']) {
        return (data['data'] as List)
            .map((json) => Equipment.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get featured products (latest products with limit)
  Future<void> getFeaturedEquipments({int limit = 12}) async {
    _setLoading(true);
    try {
      final queryParams = <String, String>{
        'page': '1',
        'per_page': limit.toString(),
      };

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.equipment}',
      ).replace(queryParameters: queryParams);

      print('=== FEATURED EQUIPMENT API CALL ===');
      print('URL: $uri');

      final response = await http.get(uri, headers: await _getHeaders());

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (data['success']) {
        final responseData = data['data'];
        final equipmentList =
            responseData is Map && responseData.containsKey('data')
                ? responseData['data']
                : responseData;

        _equipments =
            (equipmentList as List)
                .map((json) {
                  try {
                    return Equipment.fromJson(json);
                  } catch (e) {
                    print('Error parsing equipment: $e');
                    print('JSON: $json');
                    return null;
                  }
                })
                .where((equipment) => equipment != null)
                .cast<Equipment>()
                .toList();

        print('Loaded ${_equipments.length} equipments');
        _clearError();
      } else {
        _setError(data['message'] ?? 'Failed to load featured equipment');
      }
    } catch (e) {
      print('Featured equipment error: $e');
      _setError('Failed to load featured equipment: $e');
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
  void clearSelectedEquipment() {
    _selectedEquipment = null;
    notifyListeners();
  }
}
