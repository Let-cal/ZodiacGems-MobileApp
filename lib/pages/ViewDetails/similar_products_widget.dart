import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../url_API/constants.dart';
import 'view_detail_product_widget.dart';

class SimilarProductsWidget extends StatefulWidget {
  final int zodiacId;
  final int currentProductId;

  const SimilarProductsWidget({
    Key? key,
    required this.zodiacId,
    required this.currentProductId,
  }) : super(key: key);

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
    int currentPage = 1; // Track current page
    const int pageSize = ApiConstants.defaultPageSize; // Default page size
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final String getProductUrl =
        '${ApiConstants.getProductEndpoint}?page=$currentPage&pageSize=$pageSize';

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

        final filteredProducts = productList
            .where((product) => product['zodiac-id'] == widget.zodiacId)
            .toList();

        setState(() {
          _similarProducts = filteredProducts
              .where((product) =>
                  product['id'] !=
                  widget
                      .currentProductId) // Ensure not to include the same product
              .map((product) => {
                    'id': product['id'],
                    'name': product['name-product'],
                    'price': '\$${product['price']}',
                    'imageUrl': product['image-urls'][0],
                    'description': product['description-product'],
                    'zodiac-id': product['zodiac-id'],
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

  void _navigateToDetailView(
      BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDetailProductWidget(product: product),
      ),
    );
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
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _similarProducts.length,
            itemBuilder: (context, index) {
              final product = _similarProducts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () => _navigateToDetailView(context, product),
                  child: _buildSimilarProduct(
                    context,
                    product['name'],
                    product['price'],
                    product['imageUrl'],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProduct(
      BuildContext context, String name, String price, String imageUrl) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
