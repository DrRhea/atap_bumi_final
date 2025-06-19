import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../services/storage_service.dart';

class Helpers {
  // HTTP Helper
  static Future<Map<String, String>> getHeaders() async {
    final token = await StorageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> parseResponse(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to parse response: $e'};
    }
  }

  // Currency formatter
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format number with thousand separator
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(number);
  }

  // Clean phone number
  static String cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Format phone number for display
  static String formatPhoneNumber(String phone) {
    final cleanPhone = cleanPhoneNumber(phone);
    if (cleanPhone.length >= 10) {
      return '${cleanPhone.substring(0, 4)}-${cleanPhone.substring(4, 8)}-${cleanPhone.substring(8)}';
    }
    return phone;
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalize each word
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Generate initials from name
  static String getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.length == 1 && words[0].length >= 2) {
      return words[0].substring(0, 2).toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  // Show snackbar message
  static void showMessage(String message, {bool isError = false}) {
    // This will be implemented in the UI layer
    // Just a placeholder for now
    print('${isError ? 'ERROR' : 'INFO'}: $message');
  }

  // Check if string is valid email
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  // Check if string is valid phone
  static bool isValidPhone(String phone) {
    final cleanPhone = cleanPhoneNumber(phone);
    return cleanPhone.length >= 10 && cleanPhone.length <= 15;
  }

  // Get file extension
  static String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  // Check if file is image
  static bool isImageFile(String filePath) {
    final extension = getFileExtension(filePath);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  // Generate random string
  static String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (index) =>
          chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    ).join();
  }

  // Truncate string
  static String truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Remove HTML tags
  static String removeHtmlTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  // Convert bytes to human readable format
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
