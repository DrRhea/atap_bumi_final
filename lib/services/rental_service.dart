import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rental.dart';

class RentalService {
  static const String _rentalsKey = 'stored_rentals';
  
  // Save rental to local storage
  static Future<bool> saveRental({
    required double totalAmount,
    required String paymentMethod,
    required String shippingMethod,
    required String? deliveryOption,
    required String? messageForAdmin,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final now = DateTime.now();
      final rentalId = now.millisecondsSinceEpoch;
      
      // Create rental data with safe type handling
      final rentalData = {
        'id': rentalId,
        'rental_code': 'RNT$rentalId',
        'user_id': 1,
        'shipping_address_id': 1,
        'order_date': now.toIso8601String(),
        'rental_start_date': now.add(const Duration(days: 1)).toIso8601String(),
        'rental_end_date': now.add(const Duration(days: 8)).toIso8601String(),
        'rental_status': 'awaiting_payment',
        'rental_notes': messageForAdmin ?? '',
        'shipping_method': shippingMethod.toLowerCase(),
        'total_amount': totalAmount.toString(),
        'shipping_cost': '15000',
        'total_deposit': '50000',
        'payment_method': paymentMethod.toLowerCase().replaceAll(' ', '_'),
        'rental_details': cartItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          return {
            'id': rentalId + index + 1,
            'rental_id': rentalId,
            'equipment_stock_id': RentalService._safeInt(item['equipment_stock_id']) ?? RentalService._safeInt(item['equipment_id']) ?? 1,
            'unit_quantity': RentalService._safeInt(item['unit_quantity']) ?? RentalService._safeInt(item['quantity']) ?? 1,
            'rental_price_per_day': RentalService._safeInt(item['price_per_day']) ?? 50000,
            'total_days': 7,
            'total_item_price': (RentalService._safeInt(item['price_per_day']) ?? 50000) * 7 * (RentalService._safeInt(item['unit_quantity']) ?? RentalService._safeInt(item['quantity']) ?? 1),
            'return_status': 'not_returned',
            'notes': null,
            'equipment': {
              'id': RentalService._safeInt(item['equipment_id']) ?? RentalService._safeInt(item['equipment_stock_id']) ?? 1,
              'equipment_name': item['equipment_name']?.toString() ?? 'Camping Equipment',
              'rental_price_per_day': RentalService._safeInt(item['price_per_day']) ?? 50000,
              'deposit_amount': 25000,
              'detailed_description': 'Quality camping equipment for rent',
              'photos': item['image_url'] != null ? [
                {'photo_url': item['image_url'].toString()}
              ] : [],
            }
          };
        }).toList(),
      };

      // Get existing rentals
      final existingRentalsJson = prefs.getString(_rentalsKey);
      List<Map<String, dynamic>> rentals = [];
      
      if (existingRentalsJson != null) {
        final decodedData = jsonDecode(existingRentalsJson);
        rentals = List<Map<String, dynamic>>.from(decodedData);
      }
      
      // Add new rental
      rentals.add(rentalData);
      
      // Save back to preferences
      await prefs.setString(_rentalsKey, jsonEncode(rentals));
      
      return true;
    } catch (e) {
      print('Error saving rental: $e');
      return false;
    }
  }
  
  // Helper method to safely convert to int
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
  
  // Get all saved rentals
  static Future<List<Rental>> getSavedRentals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rentalsJson = prefs.getString(_rentalsKey);
      
      if (rentalsJson == null) {
        return [];
      }
      
      final decodedData = jsonDecode(rentalsJson);
      final rentals = List<Map<String, dynamic>>.from(decodedData);
      
      final validRentals = <Rental>[];
      final invalidRentals = <Map<String, dynamic>>[];
      
      for (var json in rentals) {
        try {
          final rental = Rental.fromJson(json);
          validRentals.add(rental);
        } catch (e) {
          print('Invalid rental data found: $e');
          print('Rental data: $json');
          invalidRentals.add(json);
        }
      }
      
      // If we found invalid rentals, clean them up
      if (invalidRentals.isNotEmpty) {
        print('Cleaning up ${invalidRentals.length} invalid rentals');
        await prefs.setString(_rentalsKey, jsonEncode(validRentals.map((r) => {
          'id': r.id,
          'rental_code': r.rentalCode,
          'user_id': r.userId,
          'shipping_address_id': r.shippingAddressId,
          'order_date': r.orderDate.toIso8601String(),
          'rental_start_date': r.rentalStartDate.toIso8601String(),
          'rental_end_date': r.rentalEndDate.toIso8601String(),
          'rental_status': r.rentalStatus,
          'rental_notes': r.rentalNotes,
          'shipping_method': r.shippingMethod,
          'total_amount': r.totalAmount.toString(),
          'shipping_cost': r.shippingCost.toString(),
          'total_deposit': r.totalDeposit.toString(),
          'rental_details': r.rentalDetails?.map((detail) => {
            'id': detail.id,
            'rental_id': detail.rentalId,
            'equipment_stock_id': detail.equipmentStockId,
            'unit_quantity': detail.unitQuantity,
            'rental_price_per_day': detail.rentalPricePerDay,
            'total_days': detail.totalDays,
            'total_item_price': detail.totalItemPrice,
            'return_status': detail.returnStatus,
            'notes': detail.notes,
            'equipment': detail.equipment != null ? {
              'id': detail.equipment!.id,
              'equipment_name': detail.equipment!.equipmentName,
              'rental_price_per_day': detail.equipment!.rentalPricePerDay,
              'deposit_amount': detail.equipment!.depositAmount,
              'detailed_description': detail.equipment!.detailedDescription,
              'photos': detail.equipment!.photos?.map((photo) => {
                'photo_url': photo.photoUrl
              }).toList() ?? []
            } : null
          }).toList() ?? []
        }).toList()));
      }
      
      return validRentals;
    } catch (e) {
      print('Error getting saved rentals: $e');
      // Clear corrupted data and return empty list
      await clearSavedRentals();
      return [];
    }
  }
  
  // Clear all saved rentals
  static Future<void> clearSavedRentals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rentalsKey);
  }
  
  // Update rental status
  static Future<bool> updateRentalStatus(int rentalId, String newStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rentalsJson = prefs.getString(_rentalsKey);
      
      if (rentalsJson == null) {
        return false;
      }
      
      final decodedData = jsonDecode(rentalsJson);
      final rentals = List<Map<String, dynamic>>.from(decodedData);
      
      // Find and update the rental
      for (var rental in rentals) {
        if (rental['id'] == rentalId) {
          rental['rental_status'] = newStatus;
          break;
        }
      }
      
      // Save back to preferences
      await prefs.setString(_rentalsKey, jsonEncode(rentals));
      return true;
    } catch (e) {
      print('Error updating rental status: $e');
      return false;
    }
  }
  
  // Fix corrupted rental data
  static Future<void> fixCorruptedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rentalsJson = prefs.getString(_rentalsKey);
      
      if (rentalsJson == null) return;
      
      final decodedData = jsonDecode(rentalsJson);
      final rentals = List<Map<String, dynamic>>.from(decodedData);
      
      // Filter out corrupted rentals and fix valid ones
      final fixedRentals = <Map<String, dynamic>>[];
      
      for (var rental in rentals) {
        try {
          // Try to create a Rental object to validate the data
          Rental.fromJson(rental);
          fixedRentals.add(rental);
        } catch (e) {
          print('Removing corrupted rental data: $e');
          // Skip corrupted rental
        }
      }
      
      // Save the fixed data back
      await prefs.setString(_rentalsKey, jsonEncode(fixedRentals));
      print('Fixed ${rentals.length - fixedRentals.length} corrupted rentals');
      
    } catch (e) {
      print('Error fixing corrupted data: $e');
      // If fixing fails, clear all data
      await clearSavedRentals();
    }
  }
}
