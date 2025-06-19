import 'package:atap_bumi_apps/models/equipment.dart';

class Cart {
  final int id;
  final int userId;
  final int equipmentStockId;
  final int unitQuantity;
  final DateTime plannedStartDate;
  final DateTime plannedEndDate;
  final String? notes;
  final Equipment? equipment;
  final EquipmentStock? equipmentStock;

  Cart({
    required this.id,
    required this.userId,
    required this.equipmentStockId,
    required this.unitQuantity,
    required this.plannedStartDate,
    required this.plannedEndDate,
    this.notes,
    this.equipment,
    this.equipmentStock,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json['id'],
    userId: json['user_id'],
    equipmentStockId: json['equipment_stock_id'],
    unitQuantity: json['unit_quantity'],
    plannedStartDate: DateTime.parse(json['planned_start_date']),
    plannedEndDate: DateTime.parse(json['planned_end_date']),
    notes: json['notes'],
    equipment:
        json['equipment'] != null
            ? Equipment.fromJson(json['equipment'])
            : null,
    equipmentStock:
        json['equipment_stock'] != null
            ? EquipmentStock.fromJson(json['equipment_stock'])
            : null,
  );

  Map<String, dynamic> toJson() => {
    'equipment_stock_id': equipmentStockId,
    'unit_quantity': unitQuantity,
    'planned_start_date': plannedStartDate.toIso8601String().split('T')[0],
    'planned_end_date': plannedEndDate.toIso8601String().split('T')[0],
    'notes': notes,
  };

  int get totalDays => plannedEndDate.difference(plannedStartDate).inDays + 1;
  double get subtotal =>
      (equipment?.rentalPricePerDay ?? 0) * unitQuantity * totalDays;
  double get totalDeposit => (equipment?.depositAmount ?? 0) * unitQuantity;
}

class CartItem {
  final String id;
  final String equipmentId;
  final String equipmentName;
  final int pricePerDay;
  final int quantity;
  final String? imageUrl;
  final String? description;
  final bool isSelected;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? notes;
  final String? size;
  final String? color;

  CartItem({
    required this.id,
    required this.equipmentId,
    required this.equipmentName,
    required this.pricePerDay,
    required this.quantity,
    this.imageUrl,
    this.description,
    this.isSelected = false,
    this.startDate,
    this.endDate,
    this.notes,
    this.size,
    this.color,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse price as int
    int parsePrice(dynamic price) {
      if (price == null) return 0;
      if (price is int) return price;
      if (price is double) return price.toInt();
      if (price is String) {
        try {
          return double.parse(price).toInt();
        } catch (e) {
          return 0;
        }
      }
      return 0;
    }

    return CartItem(
      id: json['id'].toString(),
      equipmentId: json['equipment_stock_id'].toString(),
      equipmentName: json['equipment_stock']?['equipment']?['equipment_name'] ?? 
                   json['equipment']?['equipment_name'] ?? 
                   'Unknown Equipment',
      pricePerDay: parsePrice(json['equipment_stock']?['equipment']?['rental_price_per_day'] ?? 
                   json['equipment']?['rental_price_per_day']),
      quantity: json['unit_quantity'] ?? 1,
      imageUrl: _getImageUrl(json),
      description: json['equipment_stock']?['equipment']?['detailed_description'] ?? 
                  json['equipment']?['detailed_description'],
      isSelected: false, // Local state for selection
      startDate: json['planned_start_date'] != null 
          ? DateTime.parse(json['planned_start_date']) 
          : null,
      endDate: json['planned_end_date'] != null 
          ? DateTime.parse(json['planned_end_date']) 
          : null,
      notes: json['notes'],
      size: json['equipment_stock']?['size'],
      color: json['equipment_stock']?['color'],
    );
  }

  static String? _getImageUrl(Map<String, dynamic> json) {
    // Try different paths for image URL - prioritize equipment_stock.equipment.photos
    if (json['equipment_stock']?['equipment']?['photos']?.isNotEmpty == true) {
      return json['equipment_stock']['equipment']['photos'][0]['photo_url'];
    }
    if (json['equipment']?['photos']?.isNotEmpty == true) {
      return json['equipment']['photos'][0]['photo_url'];
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipment_stock_id': equipmentId,
      'equipment_name': equipmentName,
      'price_per_day': pricePerDay,
      'unit_quantity': quantity,
      'image_url': imageUrl,
      'description': description,
      'planned_start_date': startDate?.toIso8601String().split('T')[0],
      'planned_end_date': endDate?.toIso8601String().split('T')[0],
      'notes': notes,
    };
  }

  CartItem copyWith({
    String? id,
    String? equipmentId,
    String? equipmentName,
    int? pricePerDay,
    int? quantity,
    String? imageUrl,
    String? description,
    bool? isSelected,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    String? size,
    String? color,
  }) {
    return CartItem(
      id: id ?? this.id,
      equipmentId: equipmentId ?? this.equipmentId,
      equipmentName: equipmentName ?? this.equipmentName,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  int get totalPrice => pricePerDay * quantity;
  
  int get daysCount {
    if (startDate != null && endDate != null) {
      return endDate!.difference(startDate!).inDays + 1;
    }
    return 1;
  }
  
  int get totalPriceForPeriod => totalPrice * daysCount;
}
