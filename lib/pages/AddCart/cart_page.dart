import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import logger package
import 'package:shared_preferences/shared_preferences.dart';

import '../NavBar/nav_bar.dart';
import '../url_API/constants.dart';
import './payment_page_widget.dart';
import 'CartItem.dart';

class CartPageWidget extends StatefulWidget {
  const CartPageWidget({super.key});

  @override
  State<CartPageWidget> get createState => _CartPageWidgetState();
}

class _CartPageWidgetState extends State<CartPageWidget> {
  late Future<CartData> cartDataFuture;
  int _selectedIndex = 0;
  final Logger _logger = Logger(); // Initialize logger
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

    if (token == null) {
      return Future.error('token_not_available');
    }

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
      _logger.d(cartItems
          .first.orderId); // Assuming orderId is the same for all items);
      return CartData(cartItems: cartItems, totalPrice: totalPrice);
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<void> deleteCartItem(int orderId, int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      return Future.error('token_not_available');
    }
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

  Future<void> checkout(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token not available');
    }

    final String completePaymentUrl =
        '${ApiConstants.orderEndpoint}/$orderId/complete-payment';

    final response = await http.put(
      Uri.parse(completePaymentUrl),
      headers: <String, String>{
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        cartDataFuture = fetchCartData();
      });
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const PaymentPageWidget()),
      );
    } else {
      throw Exception('Failed to complete payment');
    }
  }

  void handleCheckout(int orderId) {
    checkout(orderId).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Checkout Failed'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/search');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/home');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('My Cart'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_checkout),
              onPressed: () {
                Navigator.pushNamed(context, '/orders');
              },
            ),
          ],
        ),
        body: FutureBuilder<CartData>(
          future: cartDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              if (snapshot.error == 'token_not_available') {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'You need to login to view your cart',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                    child: Text('Do not have any products in your cart'));
              }
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
                }),
                const SizedBox(height: 16),
                PriceBreakdown(
                  totalPrice: cartData.totalPrice,
                  onCheckout: () {
                    checkout(cartItems.first
                        .orderId); // Assuming orderId is the same for all items
                  },
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
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
