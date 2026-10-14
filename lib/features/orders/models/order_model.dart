import 'dart:convert';

import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 1)
class OrderModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ProductModel> products;
  @HiveField(2)
  final OrderStatus status;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime? confirmedAt;
  @HiveField(5)
  final DateTime? dispatchedAt;
  @HiveField(6)
  final DateTime? outForDeliveredAt;
  @HiveField(7)
  final DateTime? deliveredAt;
  @HiveField(8)
  final double total;

  const OrderModel({
    required this.id,
    required this.products,
    required this.status,
    required this.createdAt,
    required this.total,
    this.confirmedAt,
    this.dispatchedAt,
    this.outForDeliveredAt,
    this.deliveredAt,
  });

  // 1. CopyWith Method (Crucial for state management like Bloc/Riverpod)
  OrderModel copyWith({
    String? id,
    List<ProductModel>? products,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? dispatchedAt,
    DateTime? outForDeliveredAt,
    DateTime? deliveredAt,
    double? total,
  }) {
    return OrderModel(
      id: id ?? this.id,
      products: products ?? this.products,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      dispatchedAt: dispatchedAt ?? this.dispatchedAt,
      outForDeliveredAt: outForDeliveredAt ?? this.outForDeliveredAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      total: total ?? this.total,
    );
  }

  // 2. Serialization (Convert model to a Map for databases like Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((x) => x.toJson()).toList(),
      'status': status.name, // Saves enum as a readable String
      'createdAt': createdAt
          .toIso8601String(), // ISO format is preferred for storage
      'confirmedAt': confirmedAt?.toIso8601String(),
      'dispatchedAt': dispatchedAt?.toIso8601String(),
      'outForDeliveredAt': outForDeliveredAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'total': total,
    };
  }

  // 3. Deserialization (Create model from Map incoming from database/API)
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      products: List<ProductModel>.from(
        (map['products'] as List<dynamic>?)?.map(
              (x) => ProductModel.fromJson(x as Map<String, dynamic>),
            ) ??
            const [],
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.ordered,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      confirmedAt: map['confirmedAt'] != null
          ? DateTime.parse(map['confirmedAt'])
          : null,
      dispatchedAt: map['dispatchedAt'] != null
          ? DateTime.parse(map['dispatchedAt'])
          : null,
      outForDeliveredAt: map['outForDeliveredAt'] != null
          ? DateTime.parse(map['outForDeliveredAt'])
          : null,
      deliveredAt: map['deliveredAt'] != null
          ? DateTime.parse(map['deliveredAt'])
          : null,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // 4. JSON Helpers
  String toJson() => json.encode(toMap());
  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  // 5. Equatable / toString for easier debugging
  // @override
  // String toString() {
  //   return 'OrderModel(id: $id, status: ${status.name}, total: \$${total.toStringAsFixed(2)})';
  // }
}
