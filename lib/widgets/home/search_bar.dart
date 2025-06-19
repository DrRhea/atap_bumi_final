import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final double screenWidth;
  final Function(String)? onChanged;

  const HomeSearchBar({
    super.key,
    required this.screenWidth,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenWidth * 0.12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Icon(
              Icons.search,
              color: const Color(0xFF64748B),
              size: screenWidth * 0.055,
            ),
          ),
          hintText: 'Search camping gear...',
          hintStyle: TextStyle(
            fontSize: screenWidth * 0.038,
            color: const Color(0xFF94A3B8),
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.03,
          ),
        ),
        style: TextStyle(
          fontSize: screenWidth * 0.038,
          fontFamily: 'Alexandria',
          color: const Color(0xFF1E293B),
        ),
        onChanged: onChanged ?? (value) => print('Searching for: $value'),
      ),
    );
  }
}