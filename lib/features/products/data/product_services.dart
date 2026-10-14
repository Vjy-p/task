import 'dart:developer';

import 'package:assessment/core/network/api_client.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  ProductRepository({Dio? api}) : _api = api ?? ApiClient().dio;
  final Dio _api;

  Future<List> fetchCategories() async {
    final response = await _api.get("/products/categories");
    log("resp fetch categories $response");
    return response.data;
  }

  Future<Map<String, dynamic>?> fetchProductsbyCategory({
    required String category,
    required int start,
    required int limit,
  }) async {
    final url = '/products/category/$category?skip=$start&limit=$limit';

    final response = await _api.get(url);
    log("resp fetch product by categery $response");
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>?> fetchProducts(int start, int limit) async {
    final url = '/products?skip=$start&limit=$limit';

    final response = await _api.get(url);

    log("resp fetch products $response");

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>?> searchProducts({
    required String search,
    required int index,
    required int limit,
  }) async {
    final url = '/products/search?q=$search&skip=$index&limit=$limit';

    final response = await _api.get(url);
    log("resp fetch products $response");
    return Map<String, dynamic>.from(response.data as Map);
  }
}
