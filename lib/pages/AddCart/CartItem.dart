import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartItem extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final int quantity;
  final int orderId;
  final int productId;
  final VoidCallback onDelete;

  const CartItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.orderId,
    required this.productId,
    required this.onDelete,
  });

  @override
  _CartItemState get createState => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.quantity;
  }

  Future<void> updateQuantity(int newQuantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse(
          'https://zodiacjewerlyswd.azurewebsites.net/api/orders/update-quantity'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'order-id': widget.orderId,
        'product-id': widget.productId,
        'quantity': newQuantity,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _quantity = newQuantity;
      });
    } else {
      throw Exception('Failed to update quantity');
    }
  }

  void _incrementQuantity() {
    updateQuantity(_quantity + 1);
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      updateQuantity(_quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 4,
        child: Row(
          children: [
            Image.network(
              widget.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: \$${widget.price}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _decrementQuantity,
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$_quantity'),
                      IconButton(
                        onPressed: _incrementQuantity,
                        icon: const Icon(Icons.add),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: widget.onDelete,
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
