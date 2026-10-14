import 'dart:developer';

import 'package:assessment/features/orders/data/order_repository.dart';
import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:get/state_manager.dart';

class OrderController extends GetxController {
  OrderController({OrderRepository? repository})
    : _repository = repository ?? OrderRepository.instance;

  final OrderRepository _repository;

  bool isLoading = false;
  bool error = false;

  List<OrderModel> orders = [];

  @override
  void onInit() {
    if (orders.isEmpty) {
      loadOrders();
    }
    super.onInit();
  }

  Future loadOrders() async {
    try {
      isLoading = true;
      error = false;
      update();

      orders = await _repository.getOrders();
      DateTime newDate = DateTime.now();
      for (int index = 0; index < orders.length; index++) {
        final o = orders[index];
        int hours = newDate.difference(o.createdAt).inHours;
        // log("in hours $hours");
        DateTime confirmed =
            o.confirmedAt ?? o.createdAt.add(const Duration(minutes: 2));
        DateTime dispatched =
            o.dispatchedAt ??
            o.createdAt.add(const Duration(hours: 11, minutes: 50));

        DateTime rawOutForDelivery =
            o.outForDeliveredAt ??
            o.createdAt.add(const Duration(hours: 23, minutes: 40));
        DateTime outForDelivery = _adjustToWorkingHours(rawOutForDelivery);
        DateTime delivered =
            o.deliveredAt ?? _adjustDeliveryHours(outForDelivery, o.createdAt);

        if (hours > 25) {
          orders[index] = OrderModel(
            id: o.id,
            products: o.products,
            status: OrderStatus.delivered,
            createdAt: o.createdAt,
            confirmedAt: confirmed,
            dispatchedAt: dispatched,
            outForDeliveredAt: outForDelivery,
            deliveredAt: delivered,
            total: o.total,
          );
          await _repository.updateOrder(orders[index]);
        } else if (hours >= 24) {
          orders[index] = OrderModel(
            id: o.id,
            products: o.products,
            status: OrderStatus.outForDelivery,
            createdAt: o.createdAt,
            confirmedAt: confirmed,
            dispatchedAt: dispatched,
            outForDeliveredAt: outForDelivery,
            total: o.total,
          );
          await _repository.updateOrder(orders[index]);
        } else if (hours >= 12) {
          orders[index] = OrderModel(
            id: o.id,
            products: o.products,
            status: OrderStatus.dispatched,
            createdAt: o.createdAt,
            confirmedAt: confirmed,
            dispatchedAt: dispatched,
            total: o.total,
          );
          await _repository.updateOrder(orders[index]);
        } else if (hours <= 1) {
          orders[index] = OrderModel(
            id: o.id,
            products: o.products,
            status: OrderStatus.confirmed,
            createdAt: o.createdAt,
            confirmedAt: confirmed,
            total: o.total,
          );
          await _repository.updateOrder(orders[index]);
        }
      }

      isLoading = false;
      error = false;
      update();
    } catch (e, stackTree) {
      log("Error load orders $e $stackTree");
      isLoading = false;
      error = true;
      update();
    }
  }

  Future cancelOrder({required OrderModel order}) async {
    try {
      isLoading = true;
      error = false;
      update();
      orders.removeWhere((e) => order.id == e.id);
      await _repository.deleteOrderById(order.id);

      isLoading = false;
      error = false;
      update();
    } catch (e, stackTree) {
      log("Error cancel order $e $stackTree");
      isLoading = false;
      error = true;
      update();
    }
  }

  DateTime _adjustToWorkingHours(DateTime time) {
    if (time.hour < 8) {
      return DateTime(time.year, time.month, time.day, 8, 0);
    }
    if (time.hour >= 14) {
      final nextDay = time.add(const Duration(days: 1));
      return DateTime(nextDay.year, nextDay.month, nextDay.day, 8, 0);
    }
    return time;
  }

  DateTime _adjustDeliveryHours(DateTime? time, DateTime createdAt) {
    if (time != null) {
      return time.add(const Duration(hours: 1, minutes: 6));
    } else {
      final date = createdAt.add(const Duration(hours: 24, minutes: 46));
      return date;
    }
  }
}
