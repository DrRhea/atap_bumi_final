class ApiConstants {
  // Base Configuration
  static const String baseUrl =
      // 'http://10.0.2.2:8000/api/v1'; // Android emulator
      'http://192.168.0.34:8000/api/v1'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000/api/v1'; // iOS simulator
  // static const String baseUrl = 'https://your-domain.com/api/v1'; // Production

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // HTTP Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API Version
  static const String apiVersion = 'v1';

  // Authentication Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String me = '/me';
  static const String profile = '/profile';
  static const String refreshToken = '/refresh';

  // Equipment Endpoints
  static const String equipment = '/equipment';
  static const String equipmentSearch = '/equipment/search';

  // Category Endpoints
  static const String categories = '/categories';
  static String categoryDetail(int id) => '/categories/$id';
  static String subCategories(int categoryId) =>
      '/categories/$categoryId/sub-categories';

  // Cart Endpoints
  static const String cart = '/cart';
  static String cartItem(int id) => '/cart/$id';

  // Rental Endpoints
  static const String rentals = '/rentals';
  static String rentalDetail(int id) => '/rentals/$id';
  static String rentalCancel(int id) => '/rentals/$id/cancel';

  // Payment Endpoints
  static const String payments = '/payments';
  static String paymentByRental(int rentalId) => '/payments/rental/$rentalId';
  static String paymentUpdate(int id) => '/payments/$id';

  // Address Endpoints
  static const String addresses = '/addresses';
  static String addressDetail(int id) => '/addresses/$id';

  // Review Endpoints
  static const String reviews = '/reviews';
  static const String myReviews = '/my-reviews';
  static String reviewUpdate(int id) => '/reviews/$id';

  // Return Endpoints
  static const String returns = '/returns';
  static String returnDetail(int id) => '/returns/$id';

  // Admin Endpoints
  static const String adminDashboard = '/admin/dashboard';
  static const String adminEquipment = '/admin/equipment';
  static const String adminCategories = '/admin/categories';
  static const String adminRentals = '/admin/rentals';
  static const String adminPayments = '/admin/payments';
  static const String adminReturns = '/admin/returns';

  // File Upload Endpoints
  static const String uploadEquipmentPhoto = '/admin/equipment/photos';
  static const String uploadPaymentProof = '/payments/proof';
  static const String uploadReviewPhoto = '/reviews/photos';

  // Health Check
  static const String healthCheck = '/health';

  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusValidationError = 422;
  static const int statusServerError = 500;

  // Request Headers
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Map<String, String> multipartHeaders = {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
  };

  // Pagination
  static const int defaultPerPage = 10;
  static const int maxPerPage = 50;

  // ✅ Development flags - Helper untuk deteksi development mode
  static bool get isDevelopment =>
      baseUrl.contains('10.0.2.2') ||
      baseUrl.contains('localhost') ||
      baseUrl.contains('127.0.0.1');

  // Helper method to get headers with authorization
  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }
}
