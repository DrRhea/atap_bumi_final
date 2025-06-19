import 'package:flutter/material.dart';
import '../models/address.dart';
import '../core/services/address_service.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAddresses() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AddressService.getAddresses();

      if (response['success']) {
        final addressesData = response['data'] as List;
        _addresses =
            addressesData
                .map((addressJson) => Address.fromJson(addressJson))
                .toList();
      } else {
        _setError(response['message']);
      }
    } catch (e) {
      _setError('Failed to load addresses: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addAddress(Map<String, dynamic> addressData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AddressService.addAddress(addressData);

      if (response['success']) {
        final newAddress = Address.fromJson(response['data']);
        _addresses.add(newAddress);
        notifyListeners();
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to add address: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateAddress(int id, Map<String, dynamic> addressData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AddressService.updateAddress(id, addressData);

      if (response['success']) {
        final updatedAddress = Address.fromJson(response['data']);
        final index = _addresses.indexWhere((address) => address.id == id);
        if (index != -1) {
          _addresses[index] = updatedAddress;
          notifyListeners();
        }
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to update address: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAddress(int id) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AddressService.deleteAddress(id);

      if (response['success']) {
        _addresses.removeWhere((address) => address.id == id);
        notifyListeners();
        return true;
      } else {
        _setError(response['message']);
        return false;
      }
    } catch (e) {
      _setError('Failed to delete address: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() => _clearError();
}
