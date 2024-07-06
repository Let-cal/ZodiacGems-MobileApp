import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../url_API/constants.dart';

class SimilarProductsWidget extends StatefulWidget {
  final int zodiacId;

  const SimilarProductsWidget({Key? key, required this.zodiacId})
      : super(key: key);

  @override
  _SimilarProductsWidgetState get createState => _SimilarProductsWidgetState();
}

class _SimilarProductsWidgetState extends State<SimilarProductsWidget> {
  late List<Map<String, dynamic>> _similarProducts;

  @override
  void initState() {
    super.initState();
    _similarProducts = [];
    fetchSimilarProducts();
  }

  Future<void> fetchSimilarProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    const String getProductUrl = ApiConstants.getProductEndpoint;

    try {
      final response = await http.get(
        Uri.parse(getProductUrl),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> productList = jsonData['data']['list-data'];
        setState(() {
          _similarProducts = productList
              .map((product) => {
                    'name': product['name-product'],
                    'price': '\$${product['price']}',
                    'imageUrl': product['image-urls'][0],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load similar products');
      }
    } catch (e) {
      print('Error fetching similar products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Text(
            'Similar Products',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 20,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _similarProducts.map((product) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildSimilarProduct(
                  context,
                  product['name'],
                  product['price'],
                  product['imageUrl'],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProduct(
      BuildContext context, String name, String price, String imageUrl) {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            width: 120,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 16,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
