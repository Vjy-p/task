import 'package:assessment/features/auth/controllers/auth_controller.dart';
import 'package:assessment/features/cart/controllers/cart_controller.dart';
import 'package:assessment/features/categories/controllers/categories_controller.dart';
import 'package:assessment/features/notifications/controllers/notification_controller.dart';
import 'package:assessment/features/orders/controllers/order_controller.dart';
import 'package:assessment/features/plumber/controllers/plumber_controller.dart';
import 'package:assessment/features/products/controllers/product_controller.dart';
import 'package:assessment/features/wishlist/controllers/wishlist_controller.dart';
import 'package:get/get.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => CategoriesController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => WishlistController(), fenix: true);
    Get.lazyPut(() => PlumberController(), fenix: true);
  }
}
