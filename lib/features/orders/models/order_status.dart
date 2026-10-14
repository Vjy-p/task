import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'order_status.g.dart';

@HiveType(typeId: 2)
enum OrderStatus {
  @HiveField(0)
  ordered,
  @HiveField(1)
  confirmed,
  @HiveField(2)
  dispatched,
  @HiveField(3)
  outForDelivery,
  @HiveField(4)
  delivered,
}

extension OrderStatusX on OrderStatus {
  String get title {
    switch (this) {
      case OrderStatus.ordered:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.dispatched:
        return 'Order Dispatched';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.ordered:
        return 'We have received your order.';
      case OrderStatus.confirmed:
        return 'Your order has been confirmed.';
      case OrderStatus.dispatched:
        return 'Your order is being dispatched.';
      case OrderStatus.outForDelivery:
        return 'Your order is on the way.';
      case OrderStatus.delivered:
        return 'Your order has been delivered.';
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.ordered:
        return Icons.receipt_long_rounded;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.dispatched:
        return Icons.inventory_2_outlined;
      case OrderStatus.outForDelivery:
        return Icons.local_shipping_outlined;
      case OrderStatus.delivered:
        return Icons.home_rounded;
    }
  }
}
