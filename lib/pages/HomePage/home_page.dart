import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './FilterComponents/product-filter-zodiac.dart';
import 'NavBar/nav_bar.dart';
import 'app_bar.dart';
import 'home_image_content.dart';
import 'image-section.dart';
import 'product-info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState get createState => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Default to HomePage
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://zodiacjewerly.azurewebsites.net/api/products'),
      headers: {'accept': '/'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        products = data['data'].take(4).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/about');
        break;
      default:
        break;
    }

    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  List<Widget> buildProductRows() {
    List<Widget> rows = [];
    for (int i = 0; i < products.length; i += 2) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 2 && j < products.length; j++) {
        rowChildren.add(
          ProductItem(
            imageUrl: products[j]['image-urls'][0],
            productName: products[j]['name-product'],
            price: '\$${products[j]['price']}',
          ),
        );
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ));
      rows.add(const SizedBox(height: 30));
    }
    return rows;
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
                    products.isEmpty
                        ? const CircularProgressIndicator()
                        : Column(
                            children: buildProductRows(),
                          ),
                    const SizedBox(height: 30),
                    const ImageSection(),
                    const SizedBox(height: 30),
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
