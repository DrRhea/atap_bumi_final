import 'package:atap_bumi_apps/models/category.dart';

class Equipment {
  final int id;
  final String equipmentName;
  final String equipmentSlug;
  final String sku;
  final double rentalPricePerDay;
  final double depositAmount;
  final String detailedDescription;
  final String? featuresAdvantages;
  final String? brand;
  final double? weight;
  final String? packageDimensions;
  final int minimumRentalDays;
  final int maximumRentalDays;
  final int subCategoryId;
  final bool isActive;
  final List<EquipmentPhoto>? photos;
  final List<EquipmentStock>? stock;
  final EquipmentSubCategory? subCategory;
  final double? averageRating;
  final int? totalStock;

  Equipment({
    required this.id,
    required this.equipmentName,
    required this.equipmentSlug,
    required this.sku,
    required this.rentalPricePerDay,
    required this.depositAmount,
    required this.detailedDescription,
    this.featuresAdvantages,
    this.brand,
    this.weight,
    this.packageDimensions,
    required this.minimumRentalDays,
    required this.maximumRentalDays,
    required this.subCategoryId,
    required this.isActive,
    this.photos,
    this.stock,
    this.subCategory,
    this.averageRating,
    this.totalStock,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    id: json['id'],
    equipmentName: json['equipment_name'],
    equipmentSlug: json['equipment_slug'],
    sku: json['sku'],
    rentalPricePerDay: double.parse(json['rental_price_per_day'].toString()),
    depositAmount: double.parse(json['deposit_amount'].toString()),
    detailedDescription: json['detailed_description'],
    featuresAdvantages: json['features_advantages'],
    brand: json['brand'],
    weight:
        json['weight'] != null ? double.parse(json['weight'].toString()) : null,
    packageDimensions: json['package_dimensions'],
    minimumRentalDays: json['minimum_rental_days'],
    maximumRentalDays: json['maximum_rental_days'],
    subCategoryId: json['sub_category_id'],
    isActive: json['is_active'] ?? true,
    photos:
        json['photos'] != null
            ? (json['photos'] as List)
                .map((e) => EquipmentPhoto.fromJson(e))
                .toList()
            : null,
    stock:
        json['stock'] != null
            ? (json['stock'] as List)
                .map((e) => EquipmentStock.fromJson(e))
                .toList()
            : null,
    subCategory:
        json['sub_category'] != null
            ? EquipmentSubCategory.fromJson(json['sub_category'])
            : null,
    averageRating:
        json['average_rating'] != null
            ? double.parse(json['average_rating'].toString())
            : null,
    totalStock: json['total_stock'],
  );

  String get primaryPhotoUrl =>
      photos
          ?.firstWhere(
            (p) => p.isPrimary,
            orElse: () => photos?.first ?? EquipmentPhoto.empty(),
          )
          .photoUrl ??
      '';
  
  bool get isAvailable {
    if (stock != null && stock!.isNotEmpty) {
      return stock!.any((s) => s.isAvailable);
    }
    return (totalStock ?? 0) > 0;
  }

  int get availableStockCount {
    if (stock != null && stock!.isNotEmpty) {
      return stock!
          .where((s) => s.isAvailable)
          .fold(0, (sum, s) => sum + s.availableQuantity);
    }
    return totalStock ?? 0;
  }
}

class EquipmentPhoto {
  final int id;
  final int equipmentId;
  final String photoUrl;
  final String? photoDescription;
  final int photoOrder;
  final bool isPrimary;

  EquipmentPhoto({
    required this.id,
    required this.equipmentId,
    required this.photoUrl,
    this.photoDescription,
    required this.photoOrder,
    required this.isPrimary,
  });

  factory EquipmentPhoto.fromJson(Map<String, dynamic> json) => EquipmentPhoto(
    id: json['id'],
    equipmentId: json['equipment_id'],
    photoUrl: json['photo_url'],
    photoDescription: json['photo_description'],
    photoOrder: json['photo_order'],
    isPrimary: json['is_primary'] ?? false,
  );

  factory EquipmentPhoto.empty() => EquipmentPhoto(
    id: 0,
    equipmentId: 0,
    photoUrl: '',
    photoOrder: 0,
    isPrimary: false,
  );
}

class EquipmentStock {
  final int id;
  final int equipmentId;
  final int totalQuantity;
  final int availableQuantity;
  final int reservedQuantity;
  final String? size;
  final String? color;
  final String status;

  EquipmentStock({
    required this.id,
    required this.equipmentId,
    required this.totalQuantity,
    required this.availableQuantity,
    required this.reservedQuantity,
    this.size,
    this.color,
    required this.status,
  });

  factory EquipmentStock.fromJson(Map<String, dynamic> json) => EquipmentStock(
    id: json['id'],
    equipmentId: json['equipment_id'],
    totalQuantity: json['total_quantity'],
    availableQuantity: json['available_quantity'],
    reservedQuantity: json['reserved_quantity'],
    size: json['size'],
    color: json['color'],
    status: json['status'],
  );

  bool get isAvailable => status == 'available' && availableQuantity > 0;
  String get variantName =>
      [size, color].where((e) => e != null).join(' - ').ifEmpty('Standard');
}

extension StringExtension on String {
  String ifEmpty(String defaultValue) => isEmpty ? defaultValue : this;
}
