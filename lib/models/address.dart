class Address {
  final int id;
  final String province;
  final String cityDistrict;
  final String subDistrict;
  final String postalCode;
  final String fullAddress;
  final String? additionalInformation;
  final String addressType;
  final int userId;
  final bool isDefault;
  final String? recipientName;
  final String? recipientPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    required this.id,
    required this.province,
    required this.cityDistrict,
    required this.subDistrict,
    required this.postalCode,
    required this.fullAddress,
    this.additionalInformation,
    required this.addressType,
    required this.userId,
    required this.isDefault,
    this.recipientName,
    this.recipientPhone,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] ?? 0,
    province: json['province'] ?? '',
    cityDistrict: json['city_district'] ?? '',
    subDistrict: json['sub_district'] ?? '',
    postalCode: json['postal_code'] ?? '',
    fullAddress: json['full_address'] ?? '',
    additionalInformation: json['additional_information'],
    addressType: json['address_type'] ?? 'home',
    userId: json['user_id'] ?? 0,
    isDefault: json['is_default'] ?? false,
    recipientName: json['recipient_name'],
    recipientPhone: json['recipient_phone'],
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'province': province,
    'city_district': cityDistrict,
    'sub_district': subDistrict,
    'postal_code': postalCode,
    'full_address': fullAddress,
    'additional_information': additionalInformation,
    'address_type': addressType,
    'user_id': userId,
    'is_default': isDefault,
    'recipient_name': recipientName,
    'recipient_phone': recipientPhone,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  // Helper method untuk formatted address (sesuaikan dengan yang digunakan di UI)
  String get formattedAddress {
    return '$fullAddress, $subDistrict, $cityDistrict, $province $postalCode';
  }

  // Backward compatibility
  String get completedAddress => formattedAddress;
}
