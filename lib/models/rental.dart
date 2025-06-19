import 'package:atap_bumi_apps/models/address.dart';
import 'package:atap_bumi_apps/models/equipment.dart';
import 'package:atap_bumi_apps/models/payment.dart';

class Rental {
  final int id;
  final String rentalCode;
  final int userId;
  final int shippingAddressId;
  final DateTime orderDate;
  final DateTime rentalStartDate;
  final DateTime rentalEndDate;
  final String rentalStatus;
  final String? rentalNotes;
  final String shippingMethod;
  final double totalAmount;
  final double shippingCost;
  final double totalDeposit;
  final List<RentalDetail>? rentalDetails;
  final Address? shippingAddress;
  final Payment? payment;

  Rental({
    required this.id,
    required this.rentalCode,
    required this.userId,
    required this.shippingAddressId,
    required this.orderDate,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.rentalStatus,
    this.rentalNotes,
    required this.shippingMethod,
    required this.totalAmount,
    required this.shippingCost,
    required this.totalDeposit,
    this.rentalDetails,
    this.shippingAddress,
    this.payment,
  });

  factory Rental.fromJson(Map<String, dynamic> json) => Rental(
    id: Rental._safeInt(json['id']) ?? 0,
    rentalCode: json['rental_code']?.toString() ?? '',
    userId: Rental._safeInt(json['user_id']) ?? 0,
    shippingAddressId: Rental._safeInt(json['shipping_address_id']) ?? 0,
    orderDate: DateTime.parse(json['order_date']),
    rentalStartDate: DateTime.parse(json['rental_start_date']),
    rentalEndDate: DateTime.parse(json['rental_end_date']),
    rentalStatus: json['rental_status']?.toString() ?? 'pending',
    rentalNotes: json['rental_notes']?.toString(),
    shippingMethod: json['shipping_method']?.toString() ?? 'delivery',
    totalAmount: Rental._safeDouble(json['total_amount']) ?? 0.0,
    shippingCost: Rental._safeDouble(json['shipping_cost']) ?? 0.0,
    totalDeposit: Rental._safeDouble(json['total_deposit']) ?? 0.0,
    rentalDetails:
        json['rental_details'] != null
            ? (json['rental_details'] as List)
                .map((e) => RentalDetail.fromJson(e))
                .toList()
            : null,
    shippingAddress:
        json['shipping_address'] != null
            ? Address.fromJson(json['shipping_address'])
            : null,
    payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
  );

  // Helper methods for safe type conversion
  static int? _safeInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        try {
          return double.parse(value).toInt();
        } catch (e) {
          return null;
        }
      }
    }
    return null;
  }

  static double? _safeDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'shipping_address_id': shippingAddressId,
    'rental_start_date': rentalStartDate.toIso8601String().split('T')[0],
    'rental_end_date': rentalEndDate.toIso8601String().split('T')[0],
    'shipping_method': shippingMethod,
    'rental_notes': rentalNotes,
  };

  int get totalDays => rentalEndDate.difference(rentalStartDate).inDays + 1;
  bool get canCancel =>
      ['awaiting_payment', 'processing'].contains(rentalStatus);
  bool get isActive =>
      ['processing', 'shipping', 'rented'].contains(rentalStatus);
  double get grandTotal => totalAmount + shippingCost + totalDeposit;
}

class RentalDetail {
  final int id;
  final int rentalId;
  final int equipmentStockId;
  final int unitQuantity;
  final double rentalPricePerDay;
  final int totalDays;
  final double totalItemPrice;
  final String returnStatus;
  final String? notes;
  final Equipment? equipment;

  RentalDetail({
    required this.id,
    required this.rentalId,
    required this.equipmentStockId,
    required this.unitQuantity,
    required this.rentalPricePerDay,
    required this.totalDays,
    required this.totalItemPrice,
    required this.returnStatus,
    this.notes,
    this.equipment,
  });

  factory RentalDetail.fromJson(Map<String, dynamic> json) => RentalDetail(
    id: RentalDetail._safeInt(json['id']) ?? 0,
    rentalId: RentalDetail._safeInt(json['rental_id']) ?? 0,
    equipmentStockId: RentalDetail._safeInt(json['equipment_stock_id']) ?? 0,
    unitQuantity: RentalDetail._safeInt(json['unit_quantity']) ?? 1,
    rentalPricePerDay: RentalDetail._safeDouble(json['rental_price_per_day']) ?? 0.0,
    totalDays: RentalDetail._safeInt(json['total_days']) ?? 1,
    totalItemPrice: RentalDetail._safeDouble(json['total_item_price']) ?? 0.0,
    returnStatus: json['return_status']?.toString() ?? 'not_returned',
    notes: json['notes']?.toString(),
    equipment: _parseEquipment(json),
  );

  // Helper method to parse equipment from nested structure
  static Equipment? _parseEquipment(Map<String, dynamic> json) {
    print('🔍 RentalDetail JSON keys: ${json.keys.toList()}'); // Debug: Available keys
    
    // First try to get equipment directly (for backward compatibility)
    if (json['equipment'] != null) {
      print('🔍 Found equipment directly'); // Debug
      return Equipment.fromJson(json['equipment']);
    }
    
    // Then try to get it from equipment_stock.equipment (new nested structure)
    if (json['equipment_stock'] != null) {
      print('🔍 Found equipment_stock: ${json['equipment_stock']}'); // Debug
      if (json['equipment_stock']['equipment'] != null) {
        print('🔍 Found nested equipment: ${json['equipment_stock']['equipment']}'); // Debug
        return Equipment.fromJson(json['equipment_stock']['equipment']);
      }
    }
    
    print('🔍 No equipment found in rental detail'); // Debug
    return null;
  }

  // Helper methods for safe type conversion
  static int? _safeInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        try {
          return double.parse(value).toInt();
        } catch (e) {
          return null;
        }
      }
    }
    return null;
  }

  static double? _safeDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
