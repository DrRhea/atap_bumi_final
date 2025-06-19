import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/home/home_screen.dart';
import '../screens/category/category_screen.dart';
import '../screens/order_history/order_history_screen.dart';
import '../screens/profile/profile_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth * 0.18, // Increased height for better spacing
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: screenWidth * 0.02), // Added top padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavbarItem(
                svgPath: 'assets/icon/HOME-2.svg',
                isSelected: currentIndex == 0,
                onTap: () => _navigateToPage(context, 0),
                screenWidth: screenWidth,
              ),
              NavbarItem(
                svgPath: 'assets/icon/KATEGORI.svg',
                isSelected: currentIndex == 1,
                onTap: () => _navigateToPage(context, 1),
                screenWidth: screenWidth,
              ),
              NavbarItem(
                svgPath: 'assets/icon/AKTIVITAS.svg',
                isSelected: currentIndex == 2,
                onTap: () => _navigateToPage(context, 2),
                screenWidth: screenWidth,
              ),
              NavbarItem(
                svgPath: 'assets/icon/PROFILE-2.svg',
                isSelected: currentIndex == 3,
                onTap: () => _navigateToPage(context, 3),
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    if (currentIndex == index) return; // Don't navigate if already on the page

    Widget page;
    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const CategoryScreen();
        break;
      case 2:
        page = const OrderHistoryScreen();
        break;
      case 3:
        page = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

class NavbarItem extends StatelessWidget {
  final String svgPath;
  final bool isSelected;
  final VoidCallback? onTap;
  final double screenWidth;

  const NavbarItem({
    super.key,
    required this.svgPath,
    this.isSelected = false,
    this.onTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.22,
        height: screenWidth * 0.12,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7CB342).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: screenWidth * 0.055,
            height: screenWidth * 0.055,
            colorFilter: ColorFilter.mode(
              isSelected ? const Color(0xFF7CB342) : const Color(0xFF94A3B8),
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              Icons.home,
              size: screenWidth * 0.055,
              color: isSelected
                  ? const Color(0xFF7CB342)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}