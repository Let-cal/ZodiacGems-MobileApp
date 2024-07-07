import 'package:flutter/material.dart';

import 'product_details_widget.dart'; // Import your ProductDetailsWidget
import 'product_image_widget.dart'; // Import your ProductImageWidget
import 'similar_products_widget.dart';

class ViewDetailProductWidget extends StatelessWidget {
  final Map<String, dynamic>? product;

  const ViewDetailProductWidget({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Widget
            ProductImageWidget(
              imageUrl: product?['imageUrl'] ?? '',
            ),
            // Product Details Widget
            ProductDetailsWidget(
              title: product?['name-product'] ?? 'Name of Product',
              price: '${product?['price'] ?? '500.00'}',
              description: product?['description-product'] ?? '',
            ),
            // Similar Products Widget
            SimilarProductsWidget(
              zodiacId: product?['zodiac-id'] ?? 0,
              currentProductId: product?['id'] ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}
