import 'package:flutter/material.dart';

class SimilarProductsWidget extends StatelessWidget {
  const SimilarProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
            children: [
              // Example of a similar product item
              _buildSimilarProduct(context, 'Name', '\$ Price',
                  'https://picsum.photos/seed/647/600'),
              const SizedBox(width: 20),
              _buildSimilarProduct(context, 'Name', '\$ Price',
                  'https://picsum.photos/seed/647/600'),
              const SizedBox(width: 20),
               _buildSimilarProduct(context, 'Name', '\$ Price',
                  'https://picsum.photos/seed/647/600'),
              const SizedBox(width: 20),
              // Add more similar products as needed
            ],
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
