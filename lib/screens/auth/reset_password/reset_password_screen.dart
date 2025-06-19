import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  // Helper method to build svg icon with fallback
  Widget buildSvgIcon(String assetName, IconData fallbackIcon) {
    return SvgPicture.asset(
      assetName,
      width: 22,
      height: 22,
      colorFilter: ColorFilter.mode(
        const Color(0xFF9E9E9E),
        BlendMode.srcIn,
      ),
      placeholderBuilder: (BuildContext context) {
        debugPrint('SVG fallback used for: $assetName');
        return Icon(
          fallbackIcon,
          size: 22,
          color: const Color(0xFF9E9E9E),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status bar spacing
              const SizedBox(height: 16),
              
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Reset Password header
              const Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 33,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.17,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Instruction text
              const Text(
                'Enter the email associated with your account and we\'ll send an email with instructions to reset your password',
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.17,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Email input field - Modified to use SVG icon
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x20000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                      child: buildSvgIcon(
                        'assets/icon/EMAIL.svg', 
                        Icons.email_outlined
                      ),
                    ),
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Send Instructions button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9ED99E),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Send Instructions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Bottom spacer to push indicator to bottom
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}