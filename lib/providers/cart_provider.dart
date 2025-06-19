import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cart.dart';
import '../core/constants/api_constants.dart';
import '../core/services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get total price of all items in cart
  int get totalPrice {
    return _cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  // Get selected items
  List<CartItem> get selectedItems {
    return _cartItems.where((item) => item.isSelected).toList();
  }

  // Get total price of selected items
  int get selectedTotalPrice {
    return selectedItems.fold(0, (total, item) => total + item.totalPrice);
  }

  // Get cart items count
  int get cartItemsCount => _cartItems.length;

  // Get selected items count
  int get selectedItemsCount => selectedItems.length;

  // Helper method to get headers with token
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Helper method to check if user is logged in
  Future<bool> _isUserLoggedIn() async {
    final token = await StorageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Load cart items from API
  Future<void> getCartItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check authentication using StorageService
      final isLoggedIn = await _isUserLoggedIn();
      print('User logged in: $isLoggedIn');
      
      if (!isLoggedIn) {
        // User not logged in - show empty cart
        _cartItems = [];
        _errorMessage = null; // Don't show error for empty state
        _isLoading = false;
        notifyListeners();
        return;
      }

      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}${ApiConstants.cart}';
      print('Cart request URL: $url');
      print('Cart request headers: $headers');

      // Try to fetch from API
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      print('Cart response status: ${response.statusCode}');
      print('Cart response headers: ${response.headers}');
      print('Cart response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Debug: Print response data
        print('Cart API response: $data');
        
        if (data['success'] == true) {
          // Backend mengembalikan data dengan struktur: {items: [...], total: ..., total_deposit: ..., item_count: ...}
          final responseData = data['data'];
          if (responseData != null && responseData['items'] != null) {
            final List<dynamic> cartData = responseData['items'];
            print('Cart items count: ${cartData.length}');
            
            // Debug: Print each cart item
            for (int i = 0; i < cartData.length; i++) {
              print('Cart item $i: ${cartData[i]}');
            }
            
            _cartItems = cartData.map((item) => CartItem.fromJson(item)).toList();
            print('Parsed cart items: ${_cartItems.length}');
            _errorMessage = null;
          } else {
            print('No items in cart response');
            _cartItems = [];
            _errorMessage = null;
          }
        } else {
          print('Cart API returned success: false');
          _cartItems = [];
          _errorMessage = null; // Don't show error, just empty cart
        }
      } else if (response.statusCode == 401) {
        // Token expired - clear session and show empty cart
        await StorageService.clearAll();
        _cartItems = [];
        _errorMessage = null;
      } else if (response.statusCode == 404) {
        // Cart endpoint not found or empty cart
        _cartItems = [];
        _errorMessage = null;
      } else {
        // Other errors - show empty cart
        _cartItems = [];
        _errorMessage = null;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Cart loading error: $e');
      
      // For any error - show empty cart instead of error message
      _cartItems = [];
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add item to cart
  Future<bool> addToCart({
    required String equipmentStockId,
    required int unitQuantity,
    required DateTime plannedStartDate,
    required DateTime plannedEndDate,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _isUserLoggedIn();
      if (!isLoggedIn) {
        _errorMessage = 'Please login to add items to cart';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final requestBody = {
        'equipment_stock_id': equipmentStockId,
        'unit_quantity': unitQuantity,
        'planned_start_date': plannedStartDate.toIso8601String().split('T')[0],
        'planned_end_date': plannedEndDate.toIso8601String().split('T')[0],
        'notes': notes,
      };

      print('Adding to cart: $requestBody');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cart}'),
        headers: await _getHeaders(),
        body: json.encode(requestBody),
      );

      print('Add to cart response status: ${response.statusCode}');
      print('Add to cart response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Reload cart items to get updated data
          await getCartItems();
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      final errorData = json.decode(response.body);
      _errorMessage = errorData['message'] ?? 'Failed to add item to cart';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Add to cart error: $e');
      _errorMessage = 'Network error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      final isLoggedIn = await _isUserLoggedIn();
      if (!isLoggedIn) {
        _errorMessage = 'Please login to modify cart';
        notifyListeners();
        return;
      }

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartItem(int.parse(itemId))}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        _cartItems.removeWhere((item) => item.id == itemId);
        notifyListeners();
      } else {
        _errorMessage = 'Failed to remove item from cart';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Network error occurred';
      notifyListeners();
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    if (newQuantity <= 0) return;

    try {
      final isLoggedIn = await _isUserLoggedIn();
      if (!isLoggedIn) {
        _errorMessage = 'Please login to modify cart';
        notifyListeners();
        return;
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartItem(int.parse(itemId))}'),
        headers: await _getHeaders(),
        body: json.encode({
          'unit_quantity': newQuantity,
        }),
      );

      if (response.statusCode == 200) {
        final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
        if (itemIndex >= 0) {
          _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
            quantity: newQuantity,
          );
          notifyListeners();
        }
      } else {
        _errorMessage = 'Failed to update quantity';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Network error occurred';
      notifyListeners();
    }
  }

  // Toggle item selection (local only - for checkout)
  void toggleSelection(String itemId) {
    final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex >= 0) {
      _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
        isSelected: !_cartItems[itemIndex].isSelected,
      );
      notifyListeners();
    }
  }

  // Select all items
  void selectAll() {
    _cartItems = _cartItems.map((item) => item.copyWith(isSelected: true)).toList();
    notifyListeners();
  }

  // Deselect all items
  void deselectAll() {
    _cartItems = _cartItems.map((item) => item.copyWith(isSelected: false)).toList();
    notifyListeners();
  }

  // Clear all cart items
  Future<void> clearCart() async {
    try {
      final isLoggedIn = await _isUserLoggedIn();
      if (!isLoggedIn) {
        _errorMessage = 'Please login to clear cart';
        notifyListeners();
        return;
      }

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cart}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        _cartItems.clear();
        notifyListeners();
      } else {
        _errorMessage = 'Failed to clear cart';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Network error occurred';
      notifyListeners();
    }
  }

  // Check if item exists in cart
  bool isItemInCart(String equipmentStockId) {
    return _cartItems.any((item) => item.equipmentId == equipmentStockId);
  }

  // Get item quantity in cart
  int getItemQuantity(String equipmentStockId) {
    final item = _cartItems.firstWhere(
      (item) => item.equipmentId == equipmentStockId,
      orElse: () => CartItem(
        id: '',
        equipmentId: '',
        equipmentName: '',
        pricePerDay: 0,
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh cart data
  Future<void> refreshCart() async {
    await getCartItems();
  }

  // Initialize cart (call this when user logs in)
  Future<void> initializeCart() async {
    await getCartItems();
  }
}
