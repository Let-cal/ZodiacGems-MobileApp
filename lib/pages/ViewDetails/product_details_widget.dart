import 'package:flutter/material.dart';

class ProductDetailsWidget extends StatelessWidget {
  final String title;
  final String price;
  final String description;

  const ProductDetailsWidget({
    super.key,
    required this.title,
    required this.price,
    required this.description,
  });

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
            onPressed: () {
              print('Button pressed ...');
            },
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
