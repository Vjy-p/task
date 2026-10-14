import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartRepository {
  static UserModel? get user => CommonServices().getUserDetails();

  String get _boxName {
    final id = user?.id ?? CommonServices().getUserUid();
    return id.isNotEmpty ? 'cart_$id' : 'cart';
  }

  Future<Box<ProductModel>> get _box async {
    final name = _boxName;
    if (Hive.isBoxOpen(name)) {
      return Hive.box<ProductModel>(name);
    }
    return await Hive.openBox<ProductModel>(name);
  }

  Future<void> insertCartProduct(ProductModel product) async {
    final box = await _box;
    final key = product.id ?? DateTime.now().millisecondsSinceEpoch;
    await box.put(key, product);
  }

  Future<int> updateCart(ProductModel product) async {
    final box = await _box;
    final key = product.id ?? DateTime.now().millisecondsSinceEpoch;
    await box.put(key, product);
    return 1;
  }

  Future<ProductModel?> getProductById(int id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<ProductModel>> getCart({bool newestFirst = true}) async {
    final box = await _box;
    return box.values.toList();
  }

  Future<int> deleteProductById(int id) async {
    final box = await _box;
    await box.delete(id);
    return 1;
  }

  Future<int> deleteCart() async {
    final box = await _box;
    final count = box.length;
    await box.clear();
    return count;
  }

  Future<void> close() async {
    final name = _boxName;
    if (Hive.isBoxOpen(name)) {
      await Hive.box<ProductModel>(name).close();
    }
  }
}
