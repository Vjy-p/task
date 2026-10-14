import 'dart:developer';

import 'package:assessment/features/products/data/product_services.dart';
import 'package:assessment/features/products/models/category_model.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:get/state_manager.dart';

class ProductController extends GetxController {
  ProductController({ProductRepository? repository})
    : _repository = repository ?? ProductRepository();
  final ProductRepository _repository;

  bool isLoading = false;
  bool error = false;
  bool isLastProduct = false;
  List<ProductModel> products = [];
  int limit = 10;

  bool isSearchLoading = false;
  bool errorSearch = false;
  bool isLastSearchProduct = false;
  List<ProductModel> searchedProducts = [];
  List<CategoryModel> categories = [];

  @override
  void onInit() {
    if (categories.isEmpty || products.isEmpty) {
      loadData();
    }
    super.onInit();
  }

  Future loadData() async {
    Future.wait([getCategories(), getProducts(index: 0)]);
  }

  Future<void> getCategories() async {
    try {
      isLoading = true;
      error = false;
      update();

      final resp = await _repository.fetchCategories();
      if (resp.isNotEmpty) {
        final List data = resp;
        categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      }

      isLoading = false;
      error = false;
      update();
    } catch (e, stackTree) {
      log("error category $e $stackTree");
      isLoading = false;
      error = false;
      update();
    } finally {
      isLoading = false;
      // error = false;
      update();
    }
  }

  Future<void> getProducts({required int index}) async {
    if (isLastProduct) return;

    try {
      if (index < limit) {
        isLoading = true;
        error = false;
        products.clear();
        update();
      }

      List<ProductModel> tempProducts = [];
      final resp = await _repository.fetchProducts(0, limit);
      if (resp != null) {
        final List data = resp['products'] ?? [];
        tempProducts = data.map((e) => ProductModel.fromJson(e)).toList();
        products.addAll(tempProducts);

        if (products.length < limit) {
          isLastProduct = true;
        }
      }
      isLoading = false;
      error = false;
      update();
    } catch (e, stackTree) {
      log("error products $e $stackTree");
      isLoading = false;
      error = false;
      update();
    } finally {
      isLoading = false;
      // error = false;
      update();
    }
  }

  Future<void> searchProducts({
    required String search,
    required int index,
  }) async {
    try {
      if (index < limit) {
        isSearchLoading = true;
        errorSearch = false;
        searchedProducts.clear();
        update();
      }

      List<ProductModel> tempProducts = [];

      final resp = await _repository.searchProducts(
        search: search,
        index: index,
        limit: limit,
      );

      if (resp != null) {
        final List data = resp['products'] ?? [];
        tempProducts = data.map((e) => ProductModel.fromJson(e)).toList();
        searchedProducts.addAll(tempProducts);
      }
      if (searchedProducts.length < limit) {
        isLastSearchProduct = true;
      }

      isSearchLoading = false;
      errorSearch = false;
      update();
    } catch (e, stackTree) {
      log("error search products $e $stackTree");
      isSearchLoading = false;
      errorSearch = true;
      update();
    } finally {
      isSearchLoading = false;
      // errorSearch = false;
      update();
    }
  }
}
