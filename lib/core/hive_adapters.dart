import 'package:assessment/features/cart/models/cart_model.dart';
import 'package:assessment/features/notifications/models/notification_model.dart';
import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/features/products/models/category_model.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(OrderModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(OrderStatusAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ProductModelAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(DimensionsAdapter());
  }
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(MetaAdapter());
  }
  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(ReviewAdapter());
  }
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(UserTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(NotificationModelAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(CartModelAdapter());
  }
}
