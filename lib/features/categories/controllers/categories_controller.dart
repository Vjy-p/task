import 'dart:developer';

import 'package:assessment/features/products/data/product_services.dart';
import 'package:assessment/features/products/models/category_model.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class CategoriesController extends GetxController {
  CategoriesController({ProductRepository? repository})
    : _repository = repository ?? ProductRepository();
  final ProductRepository _repository;

  List<CategoryModel> categories = [];
  bool isLastCategoryProduct = false;

  bool isLoading = false;
  bool error = false;

  List<ProductModel> products = [];
  bool isLastProduct = false;
  int limit = 10;

  bool isSearchLoading = false;
  bool errorSearch = false;
  bool isLastSearchProduct = false;
  List<ProductModel> searchedProducts = [];

  @override
  void onInit() {
    if (categories.isEmpty) {
      getCategories();
    }
    super.onInit();
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

  Future<void> getProductsByCategory({
    required String category,
    required int index,
  }) async {
    try {
      if (index < limit) {
        isLoading = true;
        error = false;
        products.clear();
        update();
      }

      List<ProductModel> tempProducts = [];

      final resp = await _repository.fetchProductsbyCategory(
        category: category ?? "",
        start: index,
        limit: limit,
      );

      if (resp != null) {
        final List data = resp['products'] ?? [];
        tempProducts = data.map((e) => ProductModel.fromJson(e)).toList();
        products.addAll(tempProducts);
      }
      if (products.length < limit) {
        isLastProduct = true;
      }
      isLoading = false;
      error = false;
      update();
    } catch (e, stackTree) {
      log("error category products $e $stackTree");
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
      update();
    }
  }
}
