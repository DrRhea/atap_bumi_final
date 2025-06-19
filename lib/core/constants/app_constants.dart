import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Atap Bumi';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Camping Equipment Rental App';

  // App Colors
  static const Color primaryColor = Color(0xFF2E7D32); // Green
  static const Color secondaryColor = Color(0xFF4CAF50); // Light Green
  static const Color accentColor = Color(0xFFFF9800); // Orange
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // App Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultMargin = 16.0;
  static const double smallMargin = 8.0;
  static const double largeMargin = 24.0;

  static const double borderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double circularBorderRadius = 50.0;

  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  // Typography
  static const double fontSizeSmall = 12.0;
  static const double fontSizeRegular = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeExtraLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 28.0;

  // Animation Duration
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Image Paths
  static const String logoPath = 'assets/icon/LOGO-1.svg';
  static const String placeholderImagePath = 'assets/images/placeholder.png';
  static const String noImagePath = 'assets/images/no-image.png';

  // Icon Paths
  static const String homeIconPath = 'assets/icon/HOME-1.svg';
  static const String categoryIconPath = 'assets/icon/KATEGORI.svg';
  static const String cartIconPath = 'assets/icon/KERANJANG.svg';
  static const String profileIconPath = 'assets/icon/PROFILE-1.svg';
  static const String searchIconPath = 'assets/icon/SEARCHING.svg';

  // Equipment Categories
  static const Map<String, String> categoryIcons = {
    'tenda': 'assets/icon/TENDA.svg',
    'sleeping-gear': 'assets/icon/TIDUR.svg',
    'cooking-equipment': 'assets/icon/MASAK.svg',
    'backpack-bags': 'assets/icon/TAS.svg',
    'pakaian': 'assets/icon/PAKAIAN.svg',
    'aksesoris': 'assets/icon/AKSESORIS.svg',
  };

  // Equipment Types
  static const List<String> equipmentTypes = [
    'Tenda',
    'Sleeping Bag',
    'Matras',
    'Kompor',
    'Cookset',
    'Carrier',
    'Daypack',
    'Headlamp',
    'Sepatu',
    'Jaket',
  ];

  // Rental Status
  static const Map<String, String> rentalStatusLabels = {
    'awaiting_payment': 'Menunggu Pembayaran',
    'processing': 'Diproses',
    'shipping': 'Dikirim',
    'rented': 'Disewa',
    'completed': 'Selesai',
    'cancelled': 'Dibatalkan',
  };

  static const Map<String, Color> rentalStatusColors = {
    'awaiting_payment': Color(0xFFFF9800), // Orange
    'processing': Color(0xFF2196F3), // Blue
    'shipping': Color(0xFF9C27B0), // Purple
    'rented': Color(0xFF4CAF50), // Green
    'completed': Color(0xFF607D8B), // Blue Grey
    'cancelled': Color(0xFFD32F2F), // Red
  };

  // Payment Methods
  static const Map<String, String> paymentMethodLabels = {
    'bank_transfer': 'Transfer Bank',
    'e_wallet': 'E-Wallet',
    'credit_card': 'Kartu Kredit',
    'cash': 'Tunai',
  };

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB

  // Regex Patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^[0-9+\-\s()]+$';
  static const String namePattern = r'^[a-zA-Z\s]+$';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd MMM yyyy';
  static const String displayDateTimeFormat = 'dd MMM yyyy, HH:mm';

  // Currency
  static const String currencySymbol = 'Rp';
  static const String currencyCode = 'IDR';

  // Default Values
  static const int defaultRentalDays = 3;
  static const int maxRentalDays = 30;
  static const int minRentalDays = 1;
  static const double defaultShippingCost = 25000;

  // Image Quality
  static const int imageQuality = 80;
  static const int thumbnailSize = 200;
  static const int maxImageDimension = 1920;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Network
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // Pagination
  static const int itemsPerPage = 10;
  static const int maxItemsPerPage = 50;

  // Rating
  static const int maxRating = 5;
  static const int minRating = 1;

  // Error Messages
  static const String networkErrorMessage = 'Tidak ada koneksi internet';
  static const String serverErrorMessage = 'Terjadi kesalahan pada server';
  static const String unknownErrorMessage =
      'Terjadi kesalahan yang tidak diketahui';
  static const String validationErrorMessage =
      'Data yang dimasukkan tidak valid';

  // Success Messages
  static const String loginSuccessMessage = 'Login berhasil';
  static const String logoutSuccessMessage = 'Logout berhasil';
  static const String registrationSuccessMessage = 'Registrasi berhasil';
  static const String updateSuccessMessage = 'Data berhasil diperbarui';
  static const String deleteSuccessMessage = 'Data berhasil dihapus';

  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Social Media
  static const String facebookUrl = 'https://facebook.com/atapbumi';
  static const String instagramUrl = 'https://instagram.com/atapbumi';
  static const String twitterUrl = 'https://twitter.com/atapbumi';
  static const String websiteUrl = 'https://atapbumi.com';

  // Contact Information
  static const String supportEmail = 'support@atapbumi.com';
  static const String supportPhone = '+62-21-1234-5678';
  static const String supportWhatsapp = '+62-812-3456-7890';
}
