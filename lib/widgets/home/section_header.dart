import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionPressed;
  final double screenWidth;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionPressed,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.w700,
            fontFamily: 'Alexandria',
            color: const Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        TextButton(
          onPressed: onActionPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenWidth * 0.01,
            ),
          ),
          child: Text(
            actionText,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: screenWidth * 0.035,
              color: const Color(0xFF7CB342),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}