import 'package:flutter/material.dart';
import 'order_item.dart';

class OrderList extends StatefulWidget {
  final String status;
  final Future<List<OrderData>> Function(String status, int page) fetchOrders;
  final int currentPage; // Add currentPage parameter

  const OrderList({
    super.key,
    required this.status,
    required this.fetchOrders,
    required this.currentPage, // Receive currentPage from parent
  });

  @override
  _OrderListState get createState  => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  late Future<List<OrderData>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = widget.fetchOrders(widget.status, widget.currentPage); // Use currentPage from widget
  }

  @override
  void didUpdateWidget(covariant OrderList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      setState(() {
        _ordersFuture = widget.fetchOrders(widget.status, widget.currentPage); // Fetch new orders when currentPage changes
      });
    }
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
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: orders.map((order) => OrderItem(order: order)).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
