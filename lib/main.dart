import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; // Import logger package
import './pages/OrderPage/order_details.dart';
import './pages/AboutUs/about_us_page.dart';
import './pages/AddCart/cart_page.dart';
import './pages/HomePage/home_page.dart';
import './pages/LoginPage/login_page.dart';
import './pages/SearchPage/search_page.dart';
import './pages/ViewDetails/view_detail_product_widget.dart';
import './pages/ProfilePage/Profile_page.dart';
import './pages/OrderPage/order_page.dart';
void main() {
  Logger.level =
      Level.debug; // Thiết lập mức độ log là debug để log tất cả các mức
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPageWidget(),
        '/viewdetails': (context) => const ViewDetailProductWidget(),
        '/addCart': (context) => const CartPageWidget(),
        '/about': (context) => const AboutUsPage(),
        '/profile': (context) => const ProfilePage(),
        '/orders': (context) => const OrderPage(),
         '/orderDetails': (context) {
          final orderId = ModalRoute.of(context)!.settings.arguments as int;
          return OrderDetails(orderId: orderId);
        },
        '/search': (context) => const SearchPage(
            initialTabIndex: 0), // Provide a default initialTabIndex
      },
    );
  }
}
