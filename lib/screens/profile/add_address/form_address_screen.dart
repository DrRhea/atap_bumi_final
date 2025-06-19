import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/address_provider.dart';
import '../../../providers/auth_provider.dart';

class FormAddressScreen extends StatefulWidget {
  const FormAddressScreen({super.key});

  @override
  State<FormAddressScreen> createState() => _FormAddressScreenState();
}

class _FormAddressScreenState extends State<FormAddressScreen> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _selectedAddressType = 'home';
  bool _isDefault = false;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
    
    // Pre-fill recipient name and phone from user profile
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      _recipientNameController.text = user.fullName;
      _phoneController.text = user.phoneNumber;
    }
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Helper method to build svg icon with fallback
  Widget buildSvgIcon(String assetName, IconData fallbackIcon) {
    return SvgPicture.asset(
      assetName,
      width: 20,
      height: 20,
      colorFilter: const ColorFilter.mode(
        Color(0xFF64748B),
        BlendMode.srcIn,
      ),
      placeholderBuilder: (BuildContext context) {
        return Icon(fallbackIcon, size: 20, color: const Color(0xFF64748B));
      },
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final addressProvider = Provider.of<AddressProvider>(context, listen: false);

      final addressData = {
        'recipient_name': _recipientNameController.text.trim(),
        'recipient_phone': _phoneController.text.trim(),
        'province': _provinceController.text.trim(),
        'city_district': _cityController.text.trim(),
        'sub_district': _districtController.text.trim(),
        'postal_code': _postalCodeController.text.trim(),
        'full_address': _addressController.text.trim(),
        'address_type': _selectedAddressType,
        'is_default': _isDefault,
      };

      print('=== FORM ADDRESS DEBUG ===');
      print('Address Data to Submit: $addressData');

      final success = await addressProvider.addAddress(addressData);

      if (success) {
        if (mounted) {
          _showSnackBar('Address added successfully!', true);
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          _showSnackBar(
            addressProvider.errorMessage ?? 'Failed to add address',
            false,
          );
        }
      }
    } catch (e) {
      print('Form Address Save Error: $e');
      if (mounted) {
        _showSnackBar('Error: $e', false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? const Color(0xFF7CB342) : const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String iconPath,
    required IconData fallbackIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
            fontFamily: 'Alexandria',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Alexandria',
              color: Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(16),
                child: buildSvgIcon(iconPath, fallbackIcon),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 16,
                fontFamily: 'Alexandria',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHalfInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String iconPath,
    required IconData fallbackIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
            fontFamily: 'Alexandria',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Alexandria',
              color: Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: buildSvgIcon(iconPath, fallbackIcon),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 16,
                fontFamily: 'Alexandria',
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      // Back button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF1E293B),
                            size: 20,
                          ),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Title
                      const Text(
                        'Add Address',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Recipient Name
                          _buildInputField(
                            label: 'Recipient Name',
                            controller: _recipientNameController,
                            hintText: 'Enter recipient name',
                            iconPath: 'assets/icon/PROFILE-2.svg',
                            fallbackIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Recipient name is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Phone Number
                          _buildInputField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            hintText: 'Enter phone number',
                            iconPath: 'assets/icon/PHONE.svg',
                            fallbackIcon: Icons.phone_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 24),

                          // Province and City
                          Row(
                            children: [
                              Expanded(
                                child: _buildHalfInputField(
                                  label: 'Province',
                                  controller: _provinceController,
                                  hintText: 'Province',
                                  iconPath: 'assets/icon/LOCATION.svg',
                                  fallbackIcon: Icons.location_on_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Province is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildHalfInputField(
                                  label: 'City/District',
                                  controller: _cityController,
                                  hintText: 'City/District',
                                  iconPath: 'assets/icon/LOCATION.svg',
                                  fallbackIcon: Icons.location_city_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'City/District is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Sub District and Postal Code
                          Row(
                            children: [
                              Expanded(
                                child: _buildHalfInputField(
                                  label: 'Sub District',
                                  controller: _districtController,
                                  hintText: 'Sub District',
                                  iconPath: 'assets/icon/LOCATION.svg',
                                  fallbackIcon: Icons.place_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Sub district is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildHalfInputField(
                                  label: 'Postal Code',
                                  controller: _postalCodeController,
                                  hintText: '12345',
                                  iconPath: 'assets/icon/LOCATION.svg',
                                  fallbackIcon: Icons.local_post_office_outlined,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Postal code is required';
                                    }
                                    if (value.length != 5) {
                                      return 'Postal code must be 5 digits';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Full Address
                          _buildInputField(
                            label: 'Full Address',
                            controller: _addressController,
                            hintText: 'Enter your complete address...',
                            iconPath: 'assets/icon/LOCATION.svg',
                            fallbackIcon: Icons.home_outlined,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full address is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Address Type Section
                          const Text(
                            'Address Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF374151),
                              fontFamily: 'Alexandria',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Address Type Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildAddressTypeCard(
                                  'Home',
                                  'home',
                                  Icons.home_outlined,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildAddressTypeCard(
                                  'Office',
                                  'office',
                                  Icons.business_outlined,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildAddressTypeCard(
                                  'Other',
                                  'other',
                                  Icons.location_on_outlined,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Set as Default
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.5,
                              ),
                            ),
                            child: CheckboxListTile(
                              title: const Text(
                                'Set as default address',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                  fontFamily: 'Alexandria',
                                ),
                              ),
                              subtitle: const Text(
                                'This address will be selected by default',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                  fontFamily: 'Alexandria',
                                ),
                              ),
                              value: _isDefault,
                              onChanged: (value) {
                                setState(() {
                                  _isDefault = value!;
                                });
                              },
                              activeColor: const Color(0xFF7CB342),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                // Save Button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: _isLoading
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                      color: _isLoading ? const Color(0xFFE2E8F0) : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isLoading
                          ? null
                          : [
                              BoxShadow(
                                color: const Color(0xFF7CB342).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : _saveAddress,
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF64748B),
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Save Address',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Alexandria',
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeCard(String title, String value, IconData icon) {
    final isSelected = _selectedAddressType == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddressType = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7CB342) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF7CB342) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? const Color(0xFF7CB342).withOpacity(0.2)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF374151),
                fontFamily: 'Alexandria',
              ),
            ),
          ],
        ),
      ),
    );
  }
}