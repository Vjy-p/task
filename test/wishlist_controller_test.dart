import 'dart:io';

import 'package:assessment/core/bindings.dart';
import 'package:assessment/core/hive_adapters.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('wishlist_controller_test');
    Hive.init(tempDir.path);
    registerHiveAdapters();
    await Hive.openBox<ProductModel>('wishlist');
    Get.reset();
  });

  tearDown(() async {
    Get.reset();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('InitialBindings properly registers WishlistController', () {
    expect(Get.isRegistered<WishlistController>(), isFalse);

    InitialBindings().dependencies();

    expect(Get.isRegistered<WishlistController>(), isTrue);
    final controller = Get.find<WishlistController>();
    expect(controller, isA<WishlistController>());
  });

  test('WishlistController toggles saved product correctly', () async {
    final controller = WishlistController();
    final testProduct = ProductModel(
      id: 101,
      title: 'Premium Faucet',
      price: 49.99,
    );

    // Save product
    await controller.toggleSaved(product: testProduct);
    expect(controller.savedIds.contains(101), isTrue);
    expect(controller.wishlistProducts.any((p) => p.id == 101), isTrue);

    // Remove product on toggle again
    await controller.toggleSaved(product: testProduct);
    expect(controller.savedIds.contains(101), isFalse);
    expect(controller.wishlistProducts.any((p) => p.id == 101), isFalse);
  });

  test('Re-registering InitialBindings after Get.reset() restores WishlistController', () {
    InitialBindings().dependencies();
    expect(Get.isRegistered<WishlistController>(), isTrue);

    Get.reset();
    expect(Get.isRegistered<WishlistController>(), isFalse);

    InitialBindings().dependencies();
    expect(Get.isRegistered<WishlistController>(), isTrue);
    expect(Get.find<WishlistController>(), isA<WishlistController>());
  });
}
