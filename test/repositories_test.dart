import 'dart:io';

import 'package:assessment/core/hive_adapters.dart';
import 'package:assessment/features/cart/data/cart_repository.dart';
import 'package:assessment/features/orders/data/order_repository.dart';
import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/wishlist/data/wishlist_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('repo_test');
    Hive.init(tempDir.path);
    registerHiveAdapters();
    await Hive.openBox<String>('user');
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CartRepository with Hive', () {
    test('insertCartProduct, getCart, getProductById, updateCart, deleteProductById, deleteCart', () async {
      final cartRepo = CartRepository();

      final product1 = ProductModel(
        id: 101,
        title: 'PVC Pipe 1 inch',
        price: 12.5,
        quantity: 2,
      );

      final product2 = ProductModel(
        id: 102,
        title: 'Elbow Joint',
        price: 4.0,
        quantity: 5,
      );

      // Insert products
      await cartRepo.insertCartProduct(product1);
      await cartRepo.insertCartProduct(product2);

      // Get cart
      List<ProductModel> cart = await cartRepo.getCart();
      expect(cart.length, 2);

      // Get product by ID
      ProductModel? fetched = await cartRepo.getProductById(101);
      expect(fetched, isNotNull);
      expect(fetched!.title, 'PVC Pipe 1 inch');
      expect(fetched.quantity, 2);

      // Update product
      product1.quantity = 4;
      await cartRepo.updateCart(product1);
      fetched = await cartRepo.getProductById(101);
      expect(fetched!.quantity, 4);

      // Delete by ID
      await cartRepo.deleteProductById(101);
      cart = await cartRepo.getCart();
      expect(cart.length, 1);
      expect(cart.first.id, 102);

      // Delete entire cart
      await cartRepo.deleteCart();
      cart = await cartRepo.getCart();
      expect(cart.isEmpty, isTrue);
    });
  });

  group('OrderRepository with Hive', () {
    test('insertOrder, saveOrders, getOrders, getOrderById, getOrdersByStatus, updateOrder, deleteOrderById, deleteAllOrders', () async {
      final orderRepo = OrderRepository.instance;

      final order1 = OrderModel(
        id: 'ORD-001',
        products: [
          ProductModel(id: 1, title: 'Item A', price: 10.0, quantity: 1),
        ],
        status: OrderStatus.ordered,
        createdAt: DateTime(2026, 1, 1, 10, 0),
        total: 10.0,
      );

      final order2 = OrderModel(
        id: 'ORD-002',
        products: [
          ProductModel(id: 2, title: 'Item B', price: 20.0, quantity: 2),
        ],
        status: OrderStatus.delivered,
        createdAt: DateTime(2026, 1, 2, 12, 0),
        total: 40.0,
      );

      // Insert single order
      await orderRepo.insertOrder(order1);

      // Save multiple orders
      await orderRepo.saveOrders([order2]);

      // Get all orders (newest first)
      List<OrderModel> orders = await orderRepo.getOrders(newestFirst: true);
      expect(orders.length, 2);
      expect(orders.first.id, 'ORD-002');
      expect(orders.last.id, 'ORD-001');

      // Get order by ID
      OrderModel? fetched = await orderRepo.getOrderById('ORD-001');
      expect(fetched, isNotNull);
      expect(fetched!.status, OrderStatus.ordered);
      expect(fetched.products.first.title, 'Item A');

      // Filter by status
      List<OrderModel> delivered = await orderRepo.getOrdersByStatus(OrderStatus.delivered);
      expect(delivered.length, 1);
      expect(delivered.first.id, 'ORD-002');

      // Update order
      final updated = order1.copyWith(status: OrderStatus.confirmed);
      await orderRepo.updateOrder(updated);
      fetched = await orderRepo.getOrderById('ORD-001');
      expect(fetched!.status, OrderStatus.confirmed);

      // Delete order by ID
      await orderRepo.deleteOrderById('ORD-001');
      orders = await orderRepo.getOrders();
      expect(orders.length, 1);
      expect(orders.first.id, 'ORD-002');

      // Delete all orders
      await orderRepo.deleteAllOrders();
      orders = await orderRepo.getOrders();
      expect(orders.isEmpty, isTrue);
    });
  });

  group('WishlistRepository with Hive', () {
    test('saveProduct, getAll, getAllSavedIds, removeProduct', () async {
      final wishlistRepo = WishlistRepository();

      final product = ProductModel(
        id: 201,
        title: 'Brass Tap',
        price: 25.0,
      );

      await wishlistRepo.saveProduct(product);
      List<ProductModel> all = await wishlistRepo.getAll();
      expect(all.length, 1);
      expect(all.first.title, 'Brass Tap');

      List<String> ids = await wishlistRepo.getAllSavedIds();
      expect(ids.contains('201'), isTrue);

      await wishlistRepo.removeProduct(201);
      all = await wishlistRepo.getAll();
      expect(all.isEmpty, isTrue);
    });
  });
}
