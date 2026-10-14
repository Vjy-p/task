import 'dart:io';

import 'package:assessment/core/hive_adapters.dart';
import 'package:assessment/features/cart/models/cart_model.dart';
import 'package:assessment/features/notifications/models/notification_model.dart';
import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/features/products/models/category_model.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_models_test');
    Hive.init(tempDir.path);
    registerHiveAdapters();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('Hive registers all model adapters and can read/write ProductModel', () async {
    final box = await Hive.openBox<ProductModel>('test_products');
    final product = ProductModel(
      id: 1,
      title: 'Test Pipe',
      description: 'Durable pipe',
      category: 'Plumbing',
      price: 15.99,
      tags: ['pipe', 'plumbing'],
      dimensions: Dimensions(width: 10.0, height: 20.0, depth: 30.0),
      meta: Meta(barcode: '12345678', qrCode: 'qr_test'),
      reviews: [
        Review(rating: 5, comment: 'Great product', reviewerName: 'John'),
      ],
      quantity: 2,
    );

    await box.put('product_1', product);
    final retrieved = box.get('product_1');

    expect(retrieved, isNotNull);
    expect(retrieved!.id, 1);
    expect(retrieved.title, 'Test Pipe');
    expect(retrieved.dimensions?.width, 10.0);
    expect(retrieved.meta?.barcode, '12345678');
    expect(retrieved.reviews.first.comment, 'Great product');
    expect(retrieved.quantity, 2);
  });

  test('Hive can read/write OrderModel with OrderStatus', () async {
    final box = await Hive.openBox<OrderModel>('test_orders');
    final order = OrderModel(
      id: 'order_123',
      products: [
        ProductModel(id: 1, title: 'Item 1'),
      ],
      status: OrderStatus.confirmed,
      createdAt: DateTime(2026, 1, 1),
      total: 99.99,
    );

    await box.put('order_1', order);
    final retrieved = box.get('order_1');

    expect(retrieved, isNotNull);
    expect(retrieved!.id, 'order_123');
    expect(retrieved.status, OrderStatus.confirmed);
    expect(retrieved.products.length, 1);
    expect(retrieved.products.first.title, 'Item 1');
  });

  test('Hive can read/write UserModel with UserType', () async {
    final box = await Hive.openBox<UserModel>('test_users');
    final user = UserModel(
      id: 'user_1',
      name: 'Alice',
      email: 'alice@test.com',
      mobileNumber: '9999999999',
      userType: UserType.dealer,
      isVerified: true,
    );

    await box.put('user_1', user);
    final retrieved = box.get('user_1');

    expect(retrieved, isNotNull);
    expect(retrieved!.name, 'Alice');
    expect(retrieved.userType, UserType.dealer);
    expect(retrieved.isVerified, true);
  });

  test('Hive can read/write CategoryModel, NotificationModel, and CartModel', () async {
    final catBox = await Hive.openBox<CategoryModel>('test_categories');
    final category = CategoryModel(slug: 'bath', name: 'Bath', url: 'https://test.com/bath');
    await catBox.put('cat_1', category);
    expect(catBox.get('cat_1')?.name, 'Bath');

    final notifBox = await Hive.openBox<NotificationModel>('test_notifications');
    final notification = NotificationModel(
      id: 'n_1',
      title: 'Alert',
      text: 'Order placed',
      date: DateTime(2026, 1, 1),
    );
    await notifBox.put('n_1', notification);
    expect(notifBox.get('n_1')?.title, 'Alert');

    final cartBox = await Hive.openBox<CartModel>('test_cart');
    final cart = CartModel(
      id: 1,
      userId: 42,
      products: [ProductModel(id: 5, title: 'Cart Item')],
      total: 50.0,
    );
    await cartBox.put('cart_1', cart);
    expect(cartBox.get('cart_1')?.products.first.title, 'Cart Item');
  });
}
