class StorageKeys {
  // Authentication Keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String tokenExpiry = 'token_expiry';
  static const String isLoggedIn = 'is_logged_in';
  static const String rememberMe = 'remember_me';

  // User Data Keys
  static const String userData = 'user_data';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userRole = 'user_role';
  static const String userMemberStatus = 'user_member_status';
  static const String profilePhoto = 'profile_photo';

  // App Settings Keys
  static const String appLanguage = 'app_language';
  static const String appTheme = 'app_theme';
  static const String isDarkMode = 'is_dark_mode';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String biometricEnabled = 'biometric_enabled';

  // Cart & Shopping Keys
  static const String cartItems = 'cart_items';
  static const String cartCount = 'cart_count';
  static const String lastCartSync = 'last_cart_sync';
  static const String wishlistItems = 'wishlist_items';

  // Search & Filter Keys
  static const String searchHistory = 'search_history';
  static const String recentSearches = 'recent_searches';
  static const String savedFilters = 'saved_filters';
  static const String lastSearchQuery = 'last_search_query';

  // Cache Keys
  static const String categoriesCache = 'categories_cache';
  static const String equipmentCache = 'equipment_cache';
  static const String reviewsCache = 'reviews_cache';
  static const String lastCacheUpdate = 'last_cache_update';

  // Location & Address Keys
  static const String defaultAddress = 'default_address';
  static const String savedAddresses = 'saved_addresses';
  static const String currentLocation = 'current_location';
  static const String locationPermission = 'location_permission';

  // Onboarding & Tutorial Keys
  static const String isFirstTime = 'is_first_time';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String tutorialShown = 'tutorial_shown';
  static const String appVersion = 'app_version';

  // Rental & Booking Keys
  static const String activeRentals = 'active_rentals';
  static const String rentalHistory = 'rental_history';
  static const String draftRental = 'draft_rental';
  static const String lastRentalDate = 'last_rental_date';

  // Payment Keys
  static const String savedPaymentMethods = 'saved_payment_methods';
  static const String preferredPaymentMethod = 'preferred_payment_method';
  static const String paymentHistory = 'payment_history';

  // Notification Keys
  static const String notificationToken = 'notification_token';
  static const String lastNotificationCheck = 'last_notification_check';
  static const String unreadNotifications = 'unread_notifications';
  static const String notificationPreferences = 'notification_preferences';

  // Analytics & Tracking Keys
  static const String sessionId = 'session_id';
  static const String deviceId = 'device_id';
  static const String installationId = 'installation_id';
  static const String lastActiveTime = 'last_active_time';
  static const String appUsageCount = 'app_usage_count';

  // Feature Flags Keys
  static const String enabledFeatures = 'enabled_features';
  static const String experimentFlags = 'experiment_flags';
  static const String betaFeatures = 'beta_features';

  // Error & Debug Keys
  static const String lastError = 'last_error';
  static const String errorLogs = 'error_logs';
  static const String debugMode = 'debug_mode';
  static const String lastCrashReport = 'last_crash_report';

  // Performance Keys
  static const String appStartTime = 'app_start_time';
  static const String loadTimes = 'load_times';
  static const String performanceMetrics = 'performance_metrics';

  // Offline Data Keys
  static const String offlineEquipment = 'offline_equipment';
  static const String offlineCategories = 'offline_categories';
  static const String pendingSyncData = 'pending_sync_data';
  static const String lastSyncTime = 'last_sync_time';

  // Security Keys
  static const String encryptionKey = 'encryption_key';
  static const String securitySettings = 'security_settings';
  static const String failedLoginAttempts = 'failed_login_attempts';
  static const String lastSecurityCheck = 'last_security_check';

  // Backup & Restore Keys
  static const String backupData = 'backup_data';
  static const String lastBackupTime = 'last_backup_time';
  static const String restoreInProgress = 'restore_in_progress';

  // Helper Methods
  static String userSpecificKey(String key, int userId) {
    return '${key}_user_$userId';
  }

  static String cacheKey(String key, {String? suffix}) {
    return suffix != null ? '${key}_$suffix' : key;
  }

  static String sessionKey(String key, String sessionId) {
    return '${key}_session_$sessionId';
  }

  // Key Groups for bulk operations
  static const List<String> authKeys = [
    accessToken,
    refreshToken,
    tokenExpiry,
    isLoggedIn,
    userData,
    userId,
    userEmail,
    userName,
    userRole,
  ];

  static const List<String> cacheKeys = [
    categoriesCache,
    equipmentCache,
    reviewsCache,
    lastCacheUpdate,
  ];

  static const List<String> cartKeys = [
    cartItems,
    cartCount,
    lastCartSync,
    wishlistItems,
  ];

  static const List<String> settingsKeys = [
    appLanguage,
    appTheme,
    isDarkMode,
    notificationsEnabled,
    biometricEnabled,
  ];

  // Clear specific key groups
  static List<String> getUserKeys(int userId) {
    return [
      userSpecificKey(cartItems, userId),
      userSpecificKey(wishlistItems, userId),
      userSpecificKey(savedAddresses, userId),
      userSpecificKey(searchHistory, userId),
    ];
  }
}
