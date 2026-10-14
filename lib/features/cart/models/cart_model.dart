import 'dart:convert';

import 'package:assessment/features/products/models/product_model.dart';
import 'package:hive/hive.dart';

part 'cart_model.g.dart';

CartModel cartModelFromJson(String str) =>
    CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

@HiveType(typeId: 11)
class CartModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? userId;
  @HiveField(2)
  final List<ProductModel> products;
  @HiveField(3)
  final double? total;

  CartModel({
    this.id,
    this.userId,
    this.products = const [],
    this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id: json["id"],
    userId: json["userId"],
    products: json["products"] == null
        ? []
        : List<ProductModel>.from(
            (json["products"] as List).map(
              (x) => ProductModel.fromJson(x as Map<String, dynamic>),
            ),
          ),
    total: json["total"] != null ? (json["total"] as num).toDouble() : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "total": total,
  };
}
