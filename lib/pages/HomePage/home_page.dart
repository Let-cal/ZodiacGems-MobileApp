import 'package:flutter/material.dart';

import './FilterComponents/product-filter-zodiac.dart';
import 'NavBar/nav_bar.dart';
import 'app_bar.dart';
import 'home_image_content.dart';
import 'image-section.dart';
import 'product-info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Default to HomePage

  void _onItemTapped(int index) {
    // Handle navigation logic here based on index
    switch (index) {
      case 0:
        // Navigate to Cart page
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 1:
        // Navigate to Search page
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        // No need to navigate to '/home' again if already on home page
        break;
      case 3:
        // Navigate to Profile page
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 4:
        // Navigate to About page
        Navigator.pushReplacementNamed(context, '/about');
        break;
      default:
        break;
    }

    // Update selected index only if navigation occurs
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    HomeImageContent(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    const SizedBox(height: 20),
                    const ProductFilter(),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1605100804763-247f67b3557e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxyaW5nfGVufDB8fHx8MTcxODE5MDg4M3ww&ixlib=rb-4.0.3&q=80&w=1080',
                          productName: 'Nhẫn Bạch Dương',
                          price: '20\$',
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1605100804763-247f67b3557e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxyaW5nfGVufDB8fHx8MTcxODE5MDg4M3ww&ixlib=rb-4.0.3&q=80&w=1080',
                          productName: 'Nhẫn Bạch Dương',
                          price: '20\$',
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const ImageSection(),
                    const SizedBox(height: 30),
                    const Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1605100804763-247f67b3557e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxyaW5nfGVufDB8fHx8MTcxODE5MDg4M3ww&ixlib=rb-4.0.3&q=80&w=1080',
                          productName: 'Nhẫn Bạch Dương',
                          price: '20\$',
                        ),
                        ProductItem(
                          imageUrl:
                              'https://images.unsplash.com/photo-1605100804763-247f67b3557e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwxfHxyaW5nfGVufDB8fHx8MTcxODE5MDg4M3ww&ixlib=rb-4.0.3&q=80&w=1080',
                          productName: 'Nhẫn Bạch Dương',
                          price: '20\$',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
