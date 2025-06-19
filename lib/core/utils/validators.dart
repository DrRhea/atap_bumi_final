class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    if (value.length > 20) {
      return 'Password maksimal 20 karakter';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak sama';
    }

    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }

    if (value.length > 50) {
      return 'Nama maksimal 50 karakter';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Nama hanya boleh berisi huruf dan spasi';
    }

    return null;
  }

  // Phone number validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    // Remove all non-digit characters
    final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanPhone.length < 10) {
      return 'Nomor telepon minimal 10 digit';
    }

    if (cleanPhone.length > 15) {
      return 'Nomor telepon maksimal 15 digit';
    }

    // Indonesian phone number format
    if (!cleanPhone.startsWith('08') && !cleanPhone.startsWith('628')) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }
    return null;
  }

  // Address validation
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat tidak boleh kosong';
    }

    if (value.length < 10) {
      return 'Alamat minimal 10 karakter';
    }

    if (value.length > 200) {
      return 'Alamat maksimal 200 karakter';
    }

    return null;
  }

  // Postal code validation (Indonesia)
  static String? postalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kode pos tidak boleh kosong';
    }

    final postalRegex = RegExp(r'^\d{5}$');
    if (!postalRegex.hasMatch(value)) {
      return 'Kode pos harus 5 digit angka';
    }

    return null;
  }

  // Number validation
  static String? number(
    String? value, {
    String? fieldName,
    int? min,
    int? max,
  }) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Angka'} tidak boleh kosong';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Field'} harus berupa angka';
    }

    if (min != null && number < min) {
      return '${fieldName ?? 'Angka'} minimal $min';
    }

    if (max != null && number > max) {
      return '${fieldName ?? 'Angka'} maksimal $max';
    }

    return null;
  }

  // Price validation
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga tidak boleh kosong';
    }

    final price = double.tryParse(value.replaceAll(',', ''));
    if (price == null) {
      return 'Format harga tidak valid';
    }

    if (price < 0) {
      return 'Harga tidak boleh negatif';
    }

    if (price > 999999999) {
      return 'Harga terlalu besar';
    }

    return null;
  }

  // Date validation
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal tidak boleh kosong';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }

  // Date of birth validation
  static String? dateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal lahir tidak boleh kosong';
    }

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final age = now.year - date.year;

      if (date.isAfter(now)) {
        return 'Tanggal lahir tidak boleh di masa depan';
      }

      if (age < 13) {
        return 'Usia minimal 13 tahun';
      }

      if (age > 100) {
        return 'Usia maksimal 100 tahun';
      }

      return null;
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }

  // Rental date validation
  static String? rentalStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal mulai sewa tidak boleh kosong';
    }

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final selectedDate = DateTime(date.year, date.month, date.day);

      if (selectedDate.isBefore(today)) {
        return 'Tanggal mulai sewa tidak boleh di masa lalu';
      }

      return null;
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }

  static String? rentalEndDate(String? value, String? startDate) {
    if (value == null || value.isEmpty) {
      return 'Tanggal selesai sewa tidak boleh kosong';
    }

    if (startDate == null || startDate.isEmpty) {
      return 'Pilih tanggal mulai sewa terlebih dahulu';
    }

    try {
      final endDate = DateTime.parse(value);
      final startDateTime = DateTime.parse(startDate);

      if (endDate.isBefore(startDateTime) ||
          endDate.isAtSameMomentAs(startDateTime)) {
        return 'Tanggal selesai harus setelah tanggal mulai';
      }

      final difference = endDate.difference(startDateTime).inDays;
      if (difference > 30) {
        return 'Maksimal sewa 30 hari';
      }

      return null;
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }

  // Quantity validation
  static String? quantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }

    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Jumlah harus berupa angka';
    }

    if (quantity < 1) {
      return 'Jumlah minimal 1';
    }

    if (quantity > 10) {
      return 'Jumlah maksimal 10';
    }

    return null;
  }

  // Rating validation
  static String? rating(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rating tidak boleh kosong';
    }

    final rating = int.tryParse(value);
    if (rating == null) {
      return 'Rating harus berupa angka';
    }

    if (rating < 1 || rating > 5) {
      return 'Rating harus antara 1-5';
    }

    return null;
  }

  // Comment validation
  static String? comment(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Comment is optional
    }

    if (value.length < 10) {
      return 'Komentar minimal 10 karakter';
    }

    if (value.length > 500) {
      return 'Komentar maksimal 500 karakter';
    }

    return null;
  }

  // Custom validation composer
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
