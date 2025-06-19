import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/inbox/inbox_screen.dart';

class HomeHeader extends StatelessWidget {
  final AuthProvider authProvider;
  final double screenWidth;

  const HomeHeader({
    super.key,
    required this.authProvider,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final user = authProvider.user;
    final isLoading = authProvider.isLoading;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E8),
            Color(0xFFF1F8E9),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: MediaQuery.of(context).size.height * 0.025,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoading)
                    Row(
                      children: [
                        Text(
                          'Hello, ',
                          style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Alexandria',
                            color: const Color(0xFF2D5016),
                            letterSpacing: -0.5,
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.07,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7CB342).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF7CB342),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Hello, ${_getFirstName(user?.fullName)}!',
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Alexandria',
                        color: const Color(0xFF2D5016),
                        letterSpacing: -0.5,
                      ),
                    ),

                  SizedBox(height: screenWidth * 0.01),

                  Text(
                    'Ready for your next adventure?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      color: const Color(0xFF5A7C47),
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),

                  if (user?.memberStatus != null && user!.memberStatus!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.02),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenWidth * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: _getMemberStatusColor(user.memberStatus),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          _getMemberStatusLabel(user.memberStatus),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Row(
              children: [
                _buildActionButton(
                  context,
                  iconPath: 'assets/icon/KERANJANG.svg',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                _buildActionButton(
                  context,
                  iconPath: 'assets/icon/MESSAGE.svg',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InboxScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: screenWidth * 0.11,
      height: screenWidth * 0.11,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF7CB342).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: screenWidth * 0.055,
              height: screenWidth * 0.055,
              colorFilter: const ColorFilter.mode(
                Color(0xFF5A7C47),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getFirstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) {
      return 'Guest';
    }
    final nameParts = fullName.trim().split(' ');
    return nameParts.isNotEmpty ? nameParts[0] : 'Guest';
  }

  Color _getMemberStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'premium':
        return const Color(0xFFFF8F00);
      case 'vip':
        return const Color(0xFF7B1FA2);
      case 'regular':
      default:
        return const Color(0xFF7CB342);
    }
  }

  String _getMemberStatusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'premium':
        return 'PREMIUM MEMBER';
      case 'vip':
        return 'VIP MEMBER';
      case 'regular':
      default:
        return 'MEMBER';
    }
  }
}