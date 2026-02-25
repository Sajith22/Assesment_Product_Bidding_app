import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/bid_history_screen.dart';

void main() {
  runApp(const BiddingAdminApp());
}

class BiddingAdminApp extends StatelessWidget {
  const BiddingAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bidding Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/products': (context) => const DashboardScreen(), // reuse with filter
        '/add-product': (context) => const AddProductScreen(),
        '/bid-history': (context) => const BidHistoryScreen(),
      },
    );
  }
}

