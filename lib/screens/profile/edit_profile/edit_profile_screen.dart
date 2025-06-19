import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> 
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? _selectedDate;

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
    
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      _nameController.text = user.fullName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
      
      // Handle date of birth parsing
      if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
        try {
          DateTime? parsedDate;
          
          if (user.dateOfBirth!.contains('T') || user.dateOfBirth!.contains('Z')) {
            parsedDate = DateTime.tryParse(user.dateOfBirth!);
          } 
          else if (user.dateOfBirth!.contains('-')) {
            parsedDate = DateTime.tryParse(user.dateOfBirth!);
          }
          else if (user.dateOfBirth!.contains('/')) {
            final parts = user.dateOfBirth!.split('/');
            if (parts.length == 3) {
              final day = int.tryParse(parts[0]);
              final month = int.tryParse(parts[1]);
              final year = int.tryParse(parts[2]);
              if (day != null && month != null && year != null) {
                final fullYear = year < 100 ? (year > 50 ? 1900 + year : 2000 + year) : year;
                parsedDate = DateTime(fullYear, month, day);
              }
            }
          }
          
          if (parsedDate != null) {
            _selectedDate = parsedDate;
            _dobController.text = _formatDateForDisplay(parsedDate);
          } else {
            _dobController.text = '';
          }
        } catch (e) {
          print('Error parsing date: $e');
          _dobController.text = '';
        }
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final profileData = {
        'full_name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'date_of_birth': _selectedDate != null 
            ? _formatDateForAPI(_selectedDate!) 
            : null,
      };

      final success = await authProvider.updateProfile(profileData);

      if (success) {
        if (mounted) {
          _showSnackBar('Profile updated successfully!', true);
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          _showSnackBar(
            authProvider.errorMessage ?? 'Failed to update profile',
            false,
          );
        }
      }
    } catch (e) {
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

  String _formatDateForDisplay(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateForAPI(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required String iconPath,
    required IconData fallbackIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
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
            readOnly: readOnly,
            onTap: onTap,
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
              suffixIcon: suffixIcon,
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
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
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
                            'Edit Profile',
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

                    // Profile Photo Section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF8FAFC),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: authProvider.user?.profilePhoto != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.network(
                                        authProvider.user!.profilePhoto!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Color(0xFF64748B),
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Color(0xFF64748B),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showSnackBar('Photo upload feature coming soon!', true);
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF7CB342), Color(0xFF8BC34A)],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF7CB342).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Form Section
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Full Name Field
                              _buildInputField(
                                label: 'Full Name',
                                controller: _nameController,
                                hintText: 'Enter your full name',
                                iconPath: 'assets/icon/PROFILE-2.svg',
                                fallbackIcon: Icons.person_outline,
                                validator: Validators.name,
                              ),

                              const SizedBox(height: 24),

                              // Email Field
                              _buildInputField(
                                label: 'Email Address',
                                controller: _emailController,
                                hintText: 'Enter your email',
                                iconPath: 'assets/icon/EMAIL.svg',
                                fallbackIcon: Icons.email_outlined,
                                validator: Validators.email,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 24),

                              // Phone Field
                              _buildInputField(
                                label: 'Phone Number',
                                controller: _phoneController,
                                hintText: 'Enter your phone number',
                                iconPath: 'assets/icon/PHONE.svg',
                                fallbackIcon: Icons.phone_outlined,
                                validator: Validators.phone,
                                keyboardType: TextInputType.phone,
                              ),

                              const SizedBox(height: 24),

                              // Date of Birth Field
                              _buildInputField(
                                label: 'Date of Birth',
                                controller: _dobController,
                                hintText: 'DD/MM/YYYY',
                                iconPath: 'assets/icon/CALENDAR.svg',
                                fallbackIcon: Icons.calendar_today_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Date of birth is required';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate ?? DateTime(2000, 1, 1),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                    helpText: 'Select your date of birth',
                                    confirmText: 'SELECT',
                                    cancelText: 'CANCEL',
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Color(0xFF7CB342),
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Color(0xFF1E293B),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDate = picked;
                                      _dobController.text = _formatDateForDisplay(picked);
                                    });
                                  }
                                },
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              // Save Button
                              Container(
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
                                    onTap: _isLoading ? null : _updateProfile,
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
                                              'Save Changes',
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

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}