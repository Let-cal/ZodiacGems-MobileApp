import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../SearchPage/menu_items.dart';
import '../ViewDetails/view_detail_product_widget.dart';
import '../url_API/constants.dart';

class OrderDetails extends StatelessWidget {
  final int orderId;

  const OrderDetails({super.key, required this.orderId});

  Future<Map<String, dynamic>> fetchOrderDetails(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final String url = '${ApiConstants.baseUrl}/orders/order/$orderId';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load order details');
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

  int _getZodiacId(String zodiacName) {
    const zodiacs = {
      1: "Aries",
      2: "Taurus",
      3: "Gemini",
      4: "Cancer",
      5: "Leo",
      6: "Virgo",
      7: "Libra",
      8: "Scorpio",
      9: "Sagittarius",
      10: "Capricorn",
      11: "Aquarius",
      12: "Pisces",
    };

    return zodiacs.entries
        .firstWhere((entry) => entry.value == zodiacName,
            orElse: () => const MapEntry(0, "Unknown"))
        .key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No details found'));
          }

          final orderDetails = snapshot.data!;
          final products = orderDetails['product'] as List<dynamic>;
          final totalPrice = orderDetails['price-total'];

          return ListView(
            children: [
              ...products.map((product) {
                return MenuItem(
                  title: product['name-product'],
                  subtext:
                      'Quantity: ${product['quantity']}, Category: ${product['name-category']}, Material: ${product['name-material']}, Gender: ${product['name-gender']}, Zodiac: ${product['zodiac-name']}',
                  description: product['description-product'],
                  imageUrl: product['image-url'],
                  price: '\$${product['price']}',
                  onTap: (ctx, prod) => _navigateToDetailView(ctx, {
                    'title': product['name-product'],
                    'description-product': product['description-product'],
                    'subtext':
                        'Quantity: ${product['quantity']}, Category: ${product['name-category']}, Material: ${product['name-material']}, Gender: ${product['name-gender']}, Zodiac: ${product['zodiac-name']}',
                    'imageUrl': product['image-url'],
                    'price': '\$${product['price']}',
                    'zodiac-id': _getZodiacId(product['zodiac-name']),
                    'id': product['product-id'],
                  }),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Price: \$$totalPrice',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
