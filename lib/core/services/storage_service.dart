import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Private helper to get SharedPreferences instance
  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ============ AUTH METHODS ============

  // Save access token
  static Future<void> setAccessToken(String token) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.accessToken, token);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.accessToken);
  }

  // Save user data
  static Future<void> setUserData(Map<String, dynamic> userData) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.userData, jsonEncode(userData));
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _instance;
    final userDataString = prefs.getString(StorageKeys.userData);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  // Set login status
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await _instance;
    await prefs.setBool(StorageKeys.isLoggedIn, isLoggedIn);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await _instance;
    return prefs.getBool(StorageKeys.isLoggedIn) ?? false;
  }

  // ============ GENERAL STORAGE METHODS ============

  // Save string
  static Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }

  // Get string
  static Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  // Save int
  static Future<void> setInt(String key, int value) async {
    final prefs = await _instance;
    await prefs.setInt(key, value);
  }

  // Get int
  static Future<int?> getInt(String key) async {
    final prefs = await _instance;
    return prefs.getInt(key);
  }

  // Save bool
  static Future<void> setBool(String key, bool value) async {
    final prefs = await _instance;
    await prefs.setBool(key, value);
  }

  // Get bool
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _instance;
    return prefs.getBool(key) ?? defaultValue;
  }

  // Save double
  static Future<void> setDouble(String key, double value) async {
    final prefs = await _instance;
    await prefs.setDouble(key, value);
  }

  // Get double
  static Future<double?> getDouble(String key) async {
    final prefs = await _instance;
    return prefs.getDouble(key);
  }

  // Save list of strings
  static Future<void> setStringList(String key, List<String> values) async {
    final prefs = await _instance;
    await prefs.setStringList(key, values);
  }

  // Get list of strings
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _instance;
    return prefs.getStringList(key);
  }

  // Save object as JSON
  static Future<void> setObject(String key, Map<String, dynamic> object) async {
    final prefs = await _instance;
    await prefs.setString(key, jsonEncode(object));
  }

  // Get object from JSON
  static Future<Map<String, dynamic>?> getObject(String key) async {
    final prefs = await _instance;
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Save list of objects as JSON
  static Future<void> setObjectList(
    String key,
    List<Map<String, dynamic>> objects,
  ) async {
    final prefs = await _instance;
    await prefs.setString(key, jsonEncode(objects));
  }

  // Get list of objects from JSON
  static Future<List<Map<String, dynamic>>?> getObjectList(String key) async {
    final prefs = await _instance;
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // ============ UTILITY METHODS ============

  // Check if key exists
  static Future<bool> hasKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }

  // Remove specific key
  static Future<void> remove(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }

  // Get all keys
  static Future<Set<String>> getAllKeys() async {
    final prefs = await _instance;
    return prefs.getKeys();
  }

  // Clear all data
  static Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.clear();
  }

  // Clear only auth related data
  static Future<void> clearAuth() async {
    final prefs = await _instance;
    await prefs.remove(StorageKeys.accessToken);
    await prefs.remove(StorageKeys.userData);
    await prefs.remove(StorageKeys.isLoggedIn);
  }

  // Clear specific keys
  static Future<void> clearKeys(List<String> keys) async {
    final prefs = await _instance;
    for (String key in keys) {
      await prefs.remove(key);
    }
  }

  // ============ APP SETTINGS METHODS ============

  // Save app theme
  static Future<void> setTheme(String theme) async {
    await setString(StorageKeys.appTheme, theme);
  }

  // Get app theme
  static Future<String> getTheme() async {
    return await getString(StorageKeys.appTheme) ?? 'light';
  }

  // Save dark mode preference
  static Future<void> setDarkMode(bool isDark) async {
    await setBool(StorageKeys.isDarkMode, isDark);
  }

  // Get dark mode preference
  static Future<bool> isDarkMode() async {
    return await getBool(StorageKeys.isDarkMode, defaultValue: false);
  }

  // Save language preference
  static Future<void> setLanguage(String languageCode) async {
    await setString(StorageKeys.appLanguage, languageCode);
  }

  // Get language preference
  static Future<String> getLanguage() async {
    return await getString(StorageKeys.appLanguage) ?? 'id';
  }

  // Save first time flag
  static Future<void> setFirstTime(bool isFirstTime) async {
    await setBool(StorageKeys.isFirstTime, isFirstTime);
  }

  // Check if first time
  static Future<bool> isFirstTime() async {
    return await getBool(StorageKeys.isFirstTime, defaultValue: true);
  }

  // ============ CART METHODS ============

  // Save cart items
  static Future<void> setCartItems(List<Map<String, dynamic>> cartItems) async {
    await setObjectList(StorageKeys.cartItems, cartItems);
  }

  // Get cart items
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    return await getObjectList(StorageKeys.cartItems) ?? [];
  }

  // Save cart count
  static Future<void> setCartCount(int count) async {
    await setInt(StorageKeys.cartCount, count);
  }

  // Get cart count
  static Future<int> getCartCount() async {
    return await getInt(StorageKeys.cartCount) ?? 0;
  }

  // Clear cart
  static Future<void> clearCart() async {
    await remove(StorageKeys.cartItems);
    await remove(StorageKeys.cartCount);
  }

  // ============ SEARCH HISTORY METHODS ============

  // Add search query to history
  static Future<void> addSearchHistory(String query) async {
    List<String> history = await getStringList(StorageKeys.searchHistory) ?? [];

    // Remove if already exists
    history.remove(query);

    // Add to beginning
    history.insert(0, query);

    // Keep only last 10 searches
    if (history.length > 10) {
      history = history.take(10).toList();
    }

    await setStringList(StorageKeys.searchHistory, history);
  }

  // Get search history
  static Future<List<String>> getSearchHistory() async {
    return await getStringList(StorageKeys.searchHistory) ?? [];
  }

  // Clear search history
  static Future<void> clearSearchHistory() async {
    await remove(StorageKeys.searchHistory);
  }

  // ============ DEBUG METHODS ============

  // Print all stored data (for debugging)
  static Future<void> printAllData() async {
    final prefs = await _instance;
    final keys = prefs.getKeys();

    print('=== ALL STORED DATA ===');
    for (String key in keys) {
      final value = prefs.get(key);
      print('$key: $value');
    }
    print('=====================');
  }

  // Get storage size (approximate)
  static Future<int> getStorageSize() async {
    final prefs = await _instance;
    final keys = prefs.getKeys();
    int totalSize = 0;

    for (String key in keys) {
      final value = prefs.get(key);
      totalSize += key.length;
      if (value is String) {
        totalSize += value.length;
      } else {
        totalSize += value.toString().length;
      }
    }

    return totalSize;
  }
}
