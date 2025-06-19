import 'package:flutter/material.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Email icon (changed to opened email style)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0E7D0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.mail, // Changed from mail_outline to mail for opened email look
                    size: 56,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Check your mail text
              const Text(
                'Check your mail',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Instruction text
              const Text(
                'We have sent a password recovery\ninstructions to your email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5A5A5A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Open Email App button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9ED99E),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0x3F000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Open Email App',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Skip text
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Skip, I\'ll confirm later',
                  style: TextStyle(
                    color: Color(0xFF5A5A5A),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const Spacer(flex: 3),
              
              // Did not receive text
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFF5A5A5A),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Did not receive the email? Check your spam filter,\nor ',
                    ),
                    TextSpan(
                      text: 'try another email address',
                      style: TextStyle(
                        color: Color(0xFFA06712),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}