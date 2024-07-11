import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../url_API/constants.dart';
import 'CartItem.dart';

class CartPageWidget extends StatefulWidget {
  const CartPageWidget({super.key});

  @override
  State<CartPageWidget> get createState => _CartPageWidgetState();
}

class _CartPageWidgetState extends State<CartPageWidget> {
  late Future<CartData> cartDataFuture;

  @override
  void initState() {
    super.initState();
    cartDataFuture = fetchCartData();
  }

  Future<CartData> fetchCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('hint');
    String? token = prefs.getString('token');
    final String getProductInCartUrl =
        '${ApiConstants.getProductInCartEndpoint}/$userId';
    if (userId == null) {
      throw Exception('User ID not found');
    }

    final response = await http.get(
      Uri.parse(getProductInCartUrl),
      headers: <String, String>{
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      List<CartItemData> cartItems = (data['product'] as List<dynamic>)
          .map((item) => CartItemData.fromJson(item))
          .toList();
      int totalPrice = data['price-total'];
      return CartData(cartItems: cartItems, totalPrice: totalPrice);
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<void> deleteCartItem(int orderId, int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final String deleteProductInCartUrl =
        '${ApiConstants.deleteProductInCartEndpoint}/$orderId/$productId';
    final response = await http.delete(
      Uri.parse(deleteProductInCartUrl),
      headers: <String, String>{
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        cartDataFuture = fetchCartData();
      });
    } else {
      throw Exception('Failed to delete cart item');
    }
  }

  void handleCheckout() {
    // Implement checkout functionality here
    print('Checkout button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('My Cart'),
        ),
        body: FutureBuilder<CartData>(
          future: cartDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            final cartData = snapshot.data!;
            final cartItems = cartData.cartItems;

            return ListView(
              children: [
                ...cartItems.map((item) {
                  return CartItem(
                    imageUrl: item.imageUrl,
                    title: item.title,
                    price: item.price.toString(),
                    quantity: item.quantity,
                    orderId: item.orderId,
                    productId: item.productId,
                    onDelete: () async {
                      await deleteCartItem(item.orderId, item.productId);
                    },
                  );
                }).toList(),
                const SizedBox(height: 16),
                PriceBreakdown(
                  totalPrice: cartData.totalPrice,
                  onCheckout: handleCheckout,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CartItemData {
  final String imageUrl;
  final String title;
  final int price;
  final int quantity;
  final int orderId;
  final int productId;

  CartItemData({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.orderId,
    required this.productId,
  });

  factory CartItemData.fromJson(Map<String, dynamic> json) {
    return CartItemData(
      imageUrl: json['image-url'],
      title: json['name-product'],
      price: json['price'],
      quantity: json['quantity'],
      orderId: json['order-id'],
      productId: json['product-id'],
    );
  }
}

class CartData {
  final List<CartItemData> cartItems;
  final int totalPrice;

  CartData({
    required this.cartItems,
    required this.totalPrice,
  });
}

class PriceBreakdown extends StatelessWidget {
  final int totalPrice;
  final VoidCallback onCheckout;

  const PriceBreakdown({
    super.key,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    int taxes = (totalPrice * 0.1).toInt(); // Assuming 10% tax rate
    int finalPrice = totalPrice + taxes;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          _buildPriceRow(context, 'Base Price', totalPrice.toString()),
          _buildPriceRow(context, 'Taxes', taxes.toString()),
          const Divider(thickness: 1.5),
          _buildPriceRow(context, 'Total', finalPrice.toString(),
              isTotal: true),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckout,
              child: const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String price,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            price,
            style: isTotal
                ? Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
