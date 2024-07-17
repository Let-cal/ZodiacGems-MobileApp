import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../url_API/constants.dart';
import 'order_item.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> get createState => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Future<List<OrderData>> fetchOrders(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('hint');
    String? token = prefs.getString('token');

    if (userId == null || token == null) {
      _logger.e('User ID or token is null');
      throw Exception('User ID or token is null');
    }

    List<OrderData> filteredOrders = [];
    int currentPage = 1;
    final int pageSize = 5;

    while (true) {
      final String getOrdersUrl =
          '${ApiConstants.baseUrl}/orders?page=$currentPage&pageSize=$pageSize&status=$status';
      _logger.d('Fetching orders from URL: $getOrdersUrl');
      final response = await http.get(
        Uri.parse(getOrdersUrl),
        headers: <String, String>{
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _logger.d('Response data: $responseData');
        final Map<String, dynamic> data = responseData['data'];
        List<OrderData> allOrders = (data['list-data'] as List<dynamic>)
            .map((item) => OrderData.fromJson(item))
            .toList();

        // Lọc đơn hàng theo userId
        List<OrderData> currentPageOrders =
            allOrders.where((order) => order.userId == userId).toList();

        filteredOrders.addAll(currentPageOrders);

        // Kiểm tra xem còn trang nào nữa không
        if (currentPage < data['total-page']) {
          currentPage++;
        } else {
          break; // Không còn trang nào để lấy nữa
        }
      } else {
        _logger.e('Failed to load orders, status code: ${response.statusCode}');
        throw Exception('Failed to load orders');
      }
    }

    // Sắp xếp đơn hàng theo ngày và lấy 10 đơn hàng mới nhất
    filteredOrders.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
    return filteredOrders.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Completed'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderList(status: '2', fetchOrders: fetchOrders),
          OrderList(status: '1', fetchOrders: fetchOrders),
        ],
      ),
    );
  }
}

class OrderList extends StatefulWidget {
  final String status;
  final Future<List<OrderData>> Function(String status) fetchOrders;

  const OrderList({
    super.key,
    required this.status,
    required this.fetchOrders,
  });

  @override
  _OrderListState get createState => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<OrderData>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = widget.fetchOrders(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderData>>(
      future: _ordersFuture,
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
