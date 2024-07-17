import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final OrderData order;

  const OrderItem({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text('Order ID: ${order.orderId}'),
        subtitle: Text('Payment Date: ${order.paymentDate}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              order.status == 2 ? 'Completed' : 'Pending',
              style: TextStyle(
                color: order.status == 2 ? Colors.green : Colors.orange,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/orderDetails',
                  arguments: order.orderId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderData {
  final int orderId;
  final int userId;
  final String paymentDate;
  final int status;

  OrderData({
    required this.orderId,
    required this.userId,
    required this.paymentDate,
    required this.status,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['id'],
      userId: json['user-id'],
      paymentDate: json['payment-date'] ?? 'No Date Provided',
      status: json['status'],
    );
  }
}