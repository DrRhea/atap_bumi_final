import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

class PageListScreen extends StatelessWidget {
  const PageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Map<String, String>>[
      // Welcome Screen
      {'title': '1. Welcome', 'route': AppRoutes.welcome},

      // Auth Screen
      {'title': '2. Sign In', 'route': AppRoutes.signIn},
      {'title': '2.1. Reset Password', 'route': AppRoutes.resetPassword},
      {'title': '2.2. Check Email', 'route': AppRoutes.checkEmail},
      {'title': '2.3. Create New Password', 'route': AppRoutes.createNewPassword},
      {'title': '3. Sign Up', 'route': AppRoutes.signUp},

      // Home Screen
      {'title': '4. Home', 'route': AppRoutes.home},
      {'title': '4.1. Articles Tips', 'route': AppRoutes.articlesTips},

      // Inbox Screen
      {'title': '5. Chat', 'route': AppRoutes.chat},
      {'title': '6. Notification', 'route': AppRoutes.notification},

      // Categories Screen
      {'title': '7. Category', 'route': AppRoutes.category},
      {'title': '7.1. Product', 'route': AppRoutes.product},
      {'title': '7.2. Detail Product', 'route': AppRoutes.detailProduct},
      {'title': '7.3. Reviews', 'route': AppRoutes.review},
      {'title': '7.4. Rating & Review', 'route': AppRoutes.ratingReview},

      // Cart Screen
      {'title': '8. Cart', 'route': AppRoutes.cart},

      // Checkout Screen
      {'title': '9. Checkout', 'route': AppRoutes.checkout},
      {'title': '9.1. Payment', 'route': AppRoutes.payment},
      {'title': '9.2. Payment Process', 'route': AppRoutes.paymentProcess},
      {'title': '9.3. Payment Confirmation', 'route': AppRoutes.paymentConfirmation},

      // Order History Screen
      {'title': '10. Order History', 'route': AppRoutes.orderHistory},
      {'title': '10.1. Order Details', 'route': AppRoutes.orderDetails},
      {'title': '10.2. Tracking Status', 'route': AppRoutes.trackingStatus},
      {'title': '10.3. Return Confirmation', 'route': AppRoutes.returnConfirmation},

      // Profile Screen
      {'title': '11. Profile', 'route': AppRoutes.profile},
      {'title': '11.1. Edit Profile', 'route': AppRoutes.editProfile},
      {'title': '11.2. Change Password', 'route': AppRoutes.changePassword},
      {'title': '11.3. Add Address', 'route': AppRoutes.addAddress},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Daftar Halaman - Kelompok 3',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '[ Scroll untuk Seluruh Halaman ]',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6FAE6F),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD0E7D0), Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, pages[index]['route']!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9ED99E),
                  foregroundColor: Colors.black,
                  elevation: 4,
                  shadowColor: Colors.green.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  pages[index]['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}