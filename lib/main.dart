import 'package:flutter/material.dart';

import './pages/HomePage/home_page.dart';
import './pages/LoginPage/login_page.dart';
import './pages/SearchPage/search_page.dart';
import './pages/ViewDetails/view_detail_product_widget.dart';

void main() {
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
      home: const LoginPageWidget(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPageWidget(),
        '/viewdetails': (context) => const ViewDetailProductWidget(),
        '/search': (context) => const SearchPage(
            initialTabIndex: 0), // Provide a default initialTabIndex
      },
    );
  }
}
