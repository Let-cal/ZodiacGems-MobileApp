import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'order_item.dart';
import '../url_API/constants.dart';

class OrderList extends StatelessWidget {
  final String status;

  const OrderList({super.key, required this.status});

  Future<List<OrderData>> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final String getOrdersUrl = '${ApiConstants.getProductInCartEndpoint}?status=$status';

    final response = await http.get(
      Uri.parse(getOrdersUrl),
      headers: <String, String>{
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => OrderData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderData>>(
      future: fetchOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found'));
        }

        final orders = snapshot.data!;
        return ListView(
          children: orders.map((order) => OrderItem(order: order)).toList(),
        );
      },
    );
  }
}
