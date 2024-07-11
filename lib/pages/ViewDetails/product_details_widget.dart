import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsWidget extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final int currentProductId;

  const ProductDetailsWidget({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.currentProductId,
  });

  Future<void> _addToCart(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('hint');
    String? token = prefs.getString('token');

    if (userId == null) {
      // Handle the case where userId is not available
      print('User ID not found');
      return;
    }

    final response = await http.post(
      Uri.parse(
          'https://zodiacjewerlyswd.azurewebsites.net/api/orders/$userId/$currentProductId'),
      headers: <String, String>{
        'accept': '/',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Product added to cart');
      Navigator.pushNamed(context, '/addCart');
    } else {
      print('Failed to add product to cart: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              color: Color(0xFFE00303),
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _addToCart(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            child: const Text('ADD TO CART'),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Outfit',
              color: Color(0xFF606A85),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'View more >',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              color: Color(0xFFF90550),
            ),
          ),
          const Divider(
            thickness: 2,
            color: Color(0xFFCCCCCC),
          ),
        ],
      ),
    );
  }
}
