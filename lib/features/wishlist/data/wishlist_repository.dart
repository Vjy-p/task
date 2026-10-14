import 'dart:developer';

import 'package:assessment/features/products/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WishlistRepository {
  static const String _boxName = 'wishlist';

  Future<Box<ProductModel>> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<ProductModel>(_boxName);
    }
    return await Hive.openBox<ProductModel>(_boxName);
  }

  Future<void> insertCartProduct(ProductModel product) async {
    final box = await _box;
    final key = product.id ?? DateTime.now().millisecondsSinceEpoch;
    await box.put(key, product);
  }

  Future<List<ProductModel>> getAll() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> saveProduct(ProductModel product) async {
    final box = await _box;
    final key = product.id ?? DateTime.now().millisecondsSinceEpoch;
    await box.put(key, product);
  }

  Future<void> removeProduct(int id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<List<String>> getAllSavedIds() async {
    final box = await _box;
    final ids = box.keys.map((k) => k.toString()).toList();
    log("ids $ids");
    return ids;
  }
}
