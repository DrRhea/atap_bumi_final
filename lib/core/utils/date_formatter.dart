import 'package:intl/intl.dart';

class DateFormatter {
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd MMM yyyy';
  static const String displayDateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String dayFormat = 'EEEE';
  static const String monthFormat = 'MMMM yyyy';
  static const String shortDateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';

  // Indonesian locale
  static const String localeId = 'id_ID';

  // Format date to string
  static String formatDate(DateTime date, {String format = displayDateFormat}) {
    try {
      return DateFormat(format, localeId).format(date);
    } catch (e) {
      return DateFormat(format).format(date);
    }
  }

  // Format date time to string
  static String formatDateTime(
    DateTime dateTime, {
    String format = displayDateTimeFormat,
  }) {
    try {
      return DateFormat(format, localeId).format(dateTime);
    } catch (e) {
      return DateFormat(format).format(dateTime);
    }
  }

  // Parse string to date
  static DateTime? parseDate(String dateString, {String format = dateFormat}) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Format for API (always yyyy-MM-dd)
  static String toApiFormat(DateTime date) {
    return DateFormat(dateFormat).format(date);
  }

  // Format for API with time (always yyyy-MM-dd HH:mm:ss)
  static String toApiDateTimeFormat(DateTime dateTime) {
    return DateFormat(dateTimeFormat).format(dateTime);
  }

  // Format for display (dd MMM yyyy)
  static String toDisplayFormat(DateTime date) {
    try {
      return DateFormat(displayDateFormat, localeId).format(date);
    } catch (e) {
      return DateFormat(displayDateFormat).format(date);
    }
  }

  // Format for display with time (dd MMM yyyy, HH:mm)
  static String toDisplayDateTimeFormat(DateTime dateTime) {
    try {
      return DateFormat(displayDateTimeFormat, localeId).format(dateTime);
    } catch (e) {
      return DateFormat(displayDateTimeFormat).format(dateTime);
    }
  }

  // Get day name (Senin, Selasa, etc.)
  static String getDayName(DateTime date) {
    try {
      return DateFormat(dayFormat, localeId).format(date);
    } catch (e) {
      final days = [
        'Minggu',
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
      ];
      return days[date.weekday % 7];
    }
  }

  // Get month name (Januari, Februari, etc.)
  static String getMonthName(DateTime date) {
    try {
      return DateFormat('MMMM', localeId).format(date);
    } catch (e) {
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return months[date.month - 1];
    }
  }

  // Get short month name (Jan, Feb, etc.)
  static String getShortMonthName(DateTime date) {
    try {
      return DateFormat('MMM', localeId).format(date);
    } catch (e) {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Ags',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return months[date.month - 1];
    }
  }

  // Get time only (HH:mm)
  static String getTimeOnly(DateTime dateTime) {
    return DateFormat(timeFormat).format(dateTime);
  }

  // Get relative time (2 hari yang lalu, besok, dll)
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    final difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == 1) {
      return 'Besok';
    } else if (difference == -1) {
      return 'Kemarin';
    } else if (difference > 1 && difference <= 7) {
      return '$difference hari lagi';
    } else if (difference < -1 && difference >= -7) {
      return '${difference.abs()} hari yang lalu';
    } else if (difference > 7) {
      return toDisplayFormat(date);
    } else {
      return toDisplayFormat(date);
    }
  }

  // Get age from date of birth
  static int getAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;

    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  // Get rental duration  static String getRentalDuration(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;

    if (difference == 1) {
      return '1 hari';
    } else {
      return '$difference hari';
    }
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  // Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Get date range text
  static String getDateRangeText(DateTime startDate, DateTime endDate) {
    if (isToday(startDate) && isToday(endDate)) {
      return 'Hari ini';
    } else if (isToday(startDate) && isTomorrow(endDate)) {
      return 'Hari ini - Besok';
    } else if (startDate.year == endDate.year &&
        startDate.month == endDate.month) {
      // Same month
      return '${startDate.day} - ${endDate.day} ${getMonthName(startDate)} ${startDate.year}';
    } else if (startDate.year == endDate.year) {
      // Same year
      return '${startDate.day} ${getShortMonthName(startDate)} - ${endDate.day} ${getShortMonthName(endDate)} ${startDate.year}';
    } else {
      // Different year
      return '${toDisplayFormat(startDate)} - ${toDisplayFormat(endDate)}';
    }
  }

  // Convert string date to DateTime (with multiple format support)
  static DateTime? parseMultipleFormats(String dateString) {
    final formats = [
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'dd-MM-yyyy',
      'yyyy-MM-dd HH:mm:ss',
      'dd/MM/yyyy HH:mm',
    ];

    for (String format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        continue;
      }
    }

    return null;
  }

  // Format for form input (dd/MM/yyyy)
  static String toFormFormat(DateTime date) {
    return DateFormat(shortDateFormat).format(date);
  }

  // Get next available rental date (excluding past dates)
  static DateTime getNextAvailableDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // If it's still morning (before 12 PM), allow today
    if (now.hour < 12) {
      return today;
    } else {
      // Otherwise, start from tomorrow
      return today.add(const Duration(days: 1));
    }
  }

  // Get minimum end date for rental (start date + 1 day)
  static DateTime getMinimumEndDate(DateTime startDate) {
    return startDate.add(const Duration(days: 1));
  }

  // Get maximum end date for rental (start date + 30 days)
  static DateTime getMaximumEndDate(DateTime startDate) {
    return startDate.add(const Duration(days: 30));
  }
}
