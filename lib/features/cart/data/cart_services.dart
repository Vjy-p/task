import 'dart:convert';
import 'dart:developer';

import 'package:assessment/core/network/api_client.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:dio/dio.dart';

class CartServices {
  CartServices({Dio? api}) : _api = api ?? ApiClient().dio;
  final Dio _api;
  final int cartId = 123456;
  final int userId = 123456;

  Future getCart() async {
    final url = "https://fakestoreapi.com/carts/$cartId";

    final response = await _api.get(url);

    return response.data;

    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> data = jsonDecode(response.body);
    //   final List? products = data['products'];
    //   return products?.map((e) => ProductModel.fromJson(e)).toList();
    // } else {
    //   throw Exception("Failed to fetch Cart");
    // }
  }

  Future createCart() async {
    const url = "https://fakestoreapi.com/carts";

    final response = await _api.post(
      url,
      data: jsonEncode({"id": cartId, "userId": userId, "products": []}),
    );
    log("create cart $response");
    return response.data;
  }

  Future updateCart({required List<ProductModel> products}) async {
    final url = "https://fakestoreapi.com/carts/$cartId";

    final response = await _api.patch(
      url,
      data: jsonEncode({"id": cartId, "userId": userId, "products": products}),
    );
    log("update cart $response");

    return response.data;
  }
}
