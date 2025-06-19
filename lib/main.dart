import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/storage_service.dart'; // ✅ Tambahkan import ini
import 'services/rental_service.dart'; // Add this import
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/equipment_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/rental_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/address_provider.dart';
import 'providers/review_provider.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialize storage service sebelum app start
  await StorageService.init();
  
  // Clean up any corrupted rental data
  try {
    await RentalService.fixCorruptedData();
  } catch (e) {
    print('Error cleaning rental data: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => EquipmentProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RentalProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MaterialApp(
        title: 'Atap Bumi Apps',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: 'Alexandria',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        
        // ✅ Untuk development/testing - langsung ke PageListScreen
        // home: const PageListScreen(),
        
        // ✅ Untuk production - gunakan proper routing
        initialRoute: AppRoutes.welcome,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
