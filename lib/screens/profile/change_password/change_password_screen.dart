import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../auth/reset_password/reset_password_screen.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChangePasswordPage();
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _passwordError;

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
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _retypePasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool _validatePassword(String password) {
    // Password must have at least 8 characters
    if (password.length < 8) {
      setState(() {
        _passwordError = 'Password must be at least 8 characters long';
      });
      return false;
    }
    
    // Password must have at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        _passwordError = 'Password must contain at least one uppercase letter';
      });
      return false;
    }
    
    // Password must have at least one number
    if (!password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        _passwordError = 'Password must contain at least one number';
      });
      return false;
    }
    
    // Password must have at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _passwordError = 'Password must contain at least one special character';
      });
      return false;
    }
    
    setState(() {
      _passwordError = null;
    });
    return true;
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      // Validate if new password matches confirmation
      if (_newPasswordController.text != _retypePasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New password and confirmation do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Validate if new password is different from old password
      if (_currentPasswordController.text == _newPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New password must be different from current password'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Validate password strength
      if (!_validatePassword(_newPasswordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_passwordError ?? 'Password does not meet requirements'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Simulasi proses ganti password
      setState(() {
        _isLoading = true;
      });
      
      // Simulasi API call dengan delay
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Password successfully changed!',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF7CB342),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 8,
          ),
        );
        
        // Reset form setelah berhasil
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _retypePasswordController.clear();
      }
    }
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
                        'Change Password',
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

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Description
                          const Text(
                            'Your new password must be different from previously used passwords and meet security requirements.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF64748B),
                              fontFamily: 'Alexandria',
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Password Requirements Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF7CB342).withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7CB342).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.security,
                                        color: Color(0xFF7CB342),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Password Requirements',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1E293B),
                                        fontFamily: 'Alexandria',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const PasswordRequirement(text: 'Minimum 8 characters'),
                                const PasswordRequirement(text: 'At least one uppercase letter (A-Z)'),
                                const PasswordRequirement(text: 'At least one number (0-9)'),
                                const PasswordRequirement(text: 'At least one special character (!@#\$%^&*)'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Current Password Field
                          const Text(
                            'Current Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                              fontFamily: 'Alexandria',
                            ),
                          ),
                          const SizedBox(height: 8),
                          PasswordInputField(
                            controller: _currentPasswordController,
                            hintText: 'Enter current password',
                            svgPath: 'assets/icon/PASSWORD.svg',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Current password is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // New Password Field
                          const Text(
                            'New Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                              fontFamily: 'Alexandria',
                            ),
                          ),
                          const SizedBox(height: 8),
                          PasswordInputField(
                            controller: _newPasswordController,
                            hintText: 'Enter new password',
                            svgPath: 'assets/icon/PASSWORD.svg',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'New password is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Confirm Password Field
                          const Text(
                            'Confirm New Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                              fontFamily: 'Alexandria',
                            ),
                          ),
                          const SizedBox(height: 8),
                          PasswordInputField(
                            controller: _retypePasswordController,
                            hintText: 'Confirm new password',
                            svgPath: 'assets/icon/PASSWORD.svg',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password confirmation is required';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Forgot Password Link
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7CB342),
                                fontFamily: 'Alexandria',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                // Change Password Button
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
                        onTap: _isLoading ? null : _changePassword,
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
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_reset,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Change Password',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Alexandria',
                                      ),
                                    ),
                                  ],
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
}

class PasswordRequirement extends StatelessWidget {
  final String text;
  
  const PasswordRequirement({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF7CB342),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                fontFamily: 'Alexandria',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String svgPath;
  final String? Function(String?)? validator;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.svgPath,
    this.validator,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator,
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
            child: buildSvgIcon(widget.svgPath, Icons.lock_outline),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF64748B),
                size: 20,
              ),
            ),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 16,
            fontFamily: 'Alexandria',
          ),
        ),
      ),
    );
  }
}