import 'package:flutter/material.dart';
import '../page_list_screen.dart';
import '../models/address.dart';
import '../models/rental.dart';

// Welcome Screen
import '../screens/welcome/welcome_screen.dart';

// Auth Screen
import '../screens/auth/sign_in/sign_in_screen.dart';
import '../screens/auth/sign_up/sign_up_screen.dart';
import '../screens/auth/check_email/check_email_screen.dart';
import '../screens/auth/reset_password/reset_password_screen.dart';
import '../screens/auth/create_new_password/create_new_password_screen.dart';

// Home Screen
import '../screens/home/home_screen.dart';
import '../screens/home/articles_tips/articles_tips_screen.dart';

// Categories Screen
import '../screens/category/category_screen.dart';
import '../screens/category/product/product_screen.dart';
import '../screens/category/rating_review/rating_review_screen.dart';
import '../screens/category/review/review_screen.dart';

// Inbox Screen
import '../screens/inbox/inbox_screen.dart';

// Cart Screen
import '../screens/cart/cart_screen.dart';

// Checkout Screen
import '../screens/checkout/checkout_screen.dart';
import '../screens/checkout/payment/payment_screen.dart';
import '../screens/checkout/payment_confirmation/payment_confirmation_screen.dart';
import '../screens/checkout/payment_process/payment_process_screen.dart';

// Order History Screen
import '../screens/order_history/order_history_screen.dart';
import '../screens/order_history/order_details/order_details_screen.dart';
import '../screens/order_history/return_confirmation/return_confirmation_screen.dart';
import '../screens/order_history/tracking_status/tracking_status_screen.dart';

// Profile Screen
import '../screens/profile/add_address/add_address_screen.dart';
import '../screens/profile/add_address/form_address_screen.dart';
import '../screens/profile/add_address/edit_address_screen.dart';
import '../screens/profile/change_password/change_password_screen.dart';
import '../screens/profile/edit_profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';

// Admin Screens
import '../screens/admin/dashboard/admin_dashboard_screen.dart';
import '../screens/admin/chat/admin_chat_screen.dart';
import '../screens/admin/transactions/admin_transactions_screen.dart';
import '../screens/admin/reports/admin_reports_screen.dart';

class AppRoutes {
  // List Of Page
  static const String pageList = '/';

  // Welcome Screen
  static const String welcome = '/welcome';

  // Auth Screen
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String checkEmail = '/check-email';
  static const String resetPassword = '/reset-password';
  static const String createNewPassword = '/create-new-password';
  static const String forgotPassword = '/forgot-password';

  // Home Screen
  static const String home = '/home';
  static const String articlesTips = '/articles-tips';

  // Categories Screen
  static const String category = '/category';
  static const String detailProduct = '/detail-product';
  static const String product = '/product';
  static const String ratingReview = '/rating-review';
  static const String review = '/review';

  // Inbox Screen
  static const String inbox = '/inbox';
  static const String chat = '/chat';
  static const String notification = '/notification';

  // Cart Screen
  static const String cart = '/cart';

  // Checkout Screen
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String paymentConfirmation = '/payment-confirmation';
  static const String paymentProcess = '/payment-process';

  // Order History Screen
  static const String orderHistory = '/order-history';
  static const String orderDetails = '/order-details';
  static const String returnConfirmation = '/return-confirmation';
  static const String trackingStatus = '/tracking-status';

  // Profile Screen
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String formAddress = '/form-address';
  static const String changePassword = '/change-password';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminChat = '/admin/chat';
  static const String adminTransactions = '/admin/transactions';
  static const String adminReports = '/admin/reports';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // List Of Page
      case pageList:
        return MaterialPageRoute(builder: (context) => const PageListScreen());

      // Welcome Screen
      case welcome:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());

      // Auth Screen
      case signIn:
        return MaterialPageRoute(builder: (context) => const SignInScreen());
      case signUp:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case checkEmail:
        return MaterialPageRoute(builder: (context) => const CheckEmailScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (context) => const ResetPasswordScreen());
      case createNewPassword:
        return MaterialPageRoute(builder: (context) => const CreateNewPasswordScreen());

      // Home Screen
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case articlesTips:
        return MaterialPageRoute(builder: (context) => const ArticlesTipsScreen());

      // Categories Screen
      case category:
        return MaterialPageRoute(builder: (context) => const CategoryScreen());
      case detailProduct:
        // DetailProductScreen sekarang menggunakan Navigator.push dengan parameter equipment
        // Route ini tidak lagi digunakan karena navigasi langsung dari ProductScreen
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Detail Product should be accessed from Product Screen'),
            ),
          ),
        );
      case product:
        return MaterialPageRoute(builder: (context) => const ProductScreen());
      case ratingReview:
        return MaterialPageRoute(builder: (context) => const RatingReviewScreen());
      case review:
        return MaterialPageRoute(builder: (context) => const ReviewScreen());

      // Inbox Screen
      case inbox:
        final tabIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (context) => InboxScreen(initialTabIndex: tabIndex),
        );
      case chat:
        return MaterialPageRoute(
          builder: (context) => const InboxScreen(initialTabIndex: 0),
        );
      case notification:
        return MaterialPageRoute(
          builder: (context) => const InboxScreen(initialTabIndex: 1),
        );

      // Cart Screen
      case cart:
        return MaterialPageRoute(builder: (context) => const CartScreen());

      // Checkout Screen
      case checkout:
        return MaterialPageRoute(builder: (context) => const CheckoutScreen());
      case payment:
        return MaterialPageRoute(builder: (context) => const PaymentScreen());
      case paymentConfirmation:
        return MaterialPageRoute(builder: (context) => const PaymentConfirmationScreen());
      case paymentProcess:
        return MaterialPageRoute(builder: (context) => const PaymentProcessScreen());

      // Order History Screen
      case orderHistory:
        return MaterialPageRoute(builder: (context) => const OrderHistoryScreen());
      case orderDetails:
        final rental = settings.arguments as Rental?;
        return MaterialPageRoute(builder: (context) => OrderDetailsScreen(rental: rental));
      case returnConfirmation:
        return MaterialPageRoute(builder: (context) => const ReturnConfirmationScreen());
      case trackingStatus:
        return MaterialPageRoute(builder: (context) => const TrackingStatusScreen());

      // Profile Screen
      case addAddress:
        return MaterialPageRoute(builder: (context) => const AddAddressScreen());
      case formAddress:
        return MaterialPageRoute(builder: (context) => const FormAddressScreen());
      case editAddress:
        final address = settings.arguments as Address?;
        if (address != null) {
          return MaterialPageRoute(builder: (context) => EditAddressScreen(address: address));
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text('Error: Address data is required for edit'),
              ),
            ),
          );
        }
      case changePassword:
        return MaterialPageRoute(builder: (context) => const ChangePasswordScreen());
      case profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (context) => const EditProfileScreen());

      // Admin Routes
      case adminDashboard:
        return MaterialPageRoute(builder: (context) => const AdminDashboardScreen());
      case adminChat:
        return MaterialPageRoute(builder: (context) => const AdminChatScreen());
      case adminTransactions:
        return MaterialPageRoute(builder: (context) => const AdminTransactionsScreen());
      case adminReports:
        return MaterialPageRoute(builder: (context) => const AdminReportsScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}