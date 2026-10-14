import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderRepository {
  OrderRepository._internal();
  static final OrderRepository instance = OrderRepository._internal();

  static UserModel? get user => CommonServices().getUserDetails();

  String get _boxName {
    final id = user?.id ?? CommonServices().getUserUid();
    return id.isNotEmpty ? 'orders_$id' : 'orders';
  }

  Future<Box<OrderModel>> get _box async {
    final name = _boxName;
    if (Hive.isBoxOpen(name)) {
      return Hive.box<OrderModel>(name);
    }
    return await Hive.openBox<OrderModel>(name);
  }

  Future<void> insertOrder(OrderModel order) async {
    final box = await _box;
    await box.put(order.id, order);
  }

  Future<void> saveOrders(List<OrderModel> orders) async {
    final box = await _box;
    final entries = {for (final order in orders) order.id: order};
    await box.putAll(entries);
  }

  Future<int> updateOrder(OrderModel order) async {
    final box = await _box;
    await box.put(order.id, order);
    return 1;
  }

  Future<OrderModel?> getOrderById(String id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<List<OrderModel>> getOrders({bool newestFirst = true}) async {
    final box = await _box;
    final list = box.values.toList();
    list.sort((a, b) => newestFirst
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    return list;
  }

  Future<List<OrderModel>> getOrdersByStatus(OrderStatus status) async {
    final box = await _box;
    final list = box.values.where((order) => order.status == status).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<int> deleteOrderById(String id) async {
    final box = await _box;
    await box.delete(id);
    return 1;
  }

  Future<int> deleteAllOrders() async {
    final box = await _box;
    final count = box.length;
    await box.clear();
    return count;
  }

  Future<void> close() async {
    final name = _boxName;
    if (Hive.isBoxOpen(name)) {
      await Hive.box<OrderModel>(name).close();
    }
  }
}
