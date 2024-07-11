import 'package:flutter/material.dart';

class OrderData {
  final int orderId;
  final String productTitle;
  final String orderStatus;
  final double totalPrice;
  final String orderDate;

  OrderData({
    required this.orderId,
    required this.productTitle,
    required this.orderStatus,
    required this.totalPrice,
    required this.orderDate,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderId: json['order-id'],
      productTitle: json['product-title'],
      orderStatus: json['order-status'],
      totalPrice: json['total-price'],
      orderDate: json['order-date'],
    );
  }
}

class OrderItem extends StatelessWidget {
  final OrderData order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.productTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: ${order.orderId}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Status: ${order.orderStatus}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: order.orderStatus == 'Completed' ? Colors.green : Colors.orange),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Total: \$${order.totalPrice}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Order Date: ${order.orderDate}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
