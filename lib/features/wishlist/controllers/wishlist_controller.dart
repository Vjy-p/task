import 'dart:developer';

import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/wishlist/data/wishlist_repository.dart';
import 'package:get/state_manager.dart';

class WishlistController extends GetxController {
  WishlistController({WishlistRepository? repository})
    : _repository = repository ?? WishlistRepository();
  final WishlistRepository _repository;

  RxList<ProductModel> wishlistProducts = <ProductModel>[].obs;
  RxList<int> savedIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWhishList();
    loadWhishListIds();
  }

  Future<void> loadWhishList() async {
    final products = await _repository.getAll();
    log("load products $products");
    wishlistProducts.assignAll(products);
    update();
  }

  Future<void> loadWhishListIds() async {
    final productIds = await _repository.getAllSavedIds();
    log("load products savedIds $productIds");
    savedIds.assignAll(
      productIds.map((id) => int.tryParse(id)).whereType<int>(),
    );
    update();
  }

  Future<void> toggleSaved({required ProductModel product}) async {
    int id = product.id ?? 0;
    if (savedIds.contains(id)) {
      savedIds.remove(id);
      wishlistProducts.removeWhere((e) => e.id == id);
      await _repository.removeProduct(id);
    } else {
      savedIds.add(id);
      wishlistProducts.add(product);
      await _repository.saveProduct(product);
    }
    update();
  }
}
