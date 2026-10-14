import 'dart:developer';

import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/cart/data/cart_repository.dart';
import 'package:assessment/features/customer/views/customer_dashboard.dart';
import 'package:assessment/features/delear/views/delear_dashboard.dart';
import 'package:assessment/features/orders/data/order_repository.dart';
import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/main.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  CartController({CartRepository? repository})
    : _repository = repository ?? CartRepository();
  final CartRepository _repository;

  bool isLoading = false;
  bool isButtonLoading = false;

  List<ProductModel> cartProducts = [];
  double totalPrice = 0;

  List<int> creditPayments = [30, 90];
  int? selectedCreditPayment;

  @override
  void onInit() {
    if (cartProducts.isEmpty) {
      loadCart();
    }
    super.onInit();
  }

  void changePayLater({required int val}) {
    selectedCreditPayment = val;
    update();
  }

  Future<void> loadCart() async {
    try {
      isLoading = true;
      update();
      cartProducts = await _repository.getCart();
      getTotalPrice();
      isLoading = false;
      update();
    } catch (e, stackTree) {
      isLoading = false;
      update();
      log("Error cart $e $stackTree");
    }
  }

  void getTotalPrice() {
    totalPrice = 0;
    for (ProductModel p in cartProducts) {
      totalPrice += p.quantity * (p.price ?? 0);
    }
    totalPrice = double.parse(totalPrice.toStringAsFixed(2));
  }

  Future<void> updateProduct({required ProductModel product}) async {
    try {
      int index = cartProducts.isEmpty
          ? -1
          : cartProducts.indexWhere((e) => e.id == product.id);

      log("update cart index $index ${product.quantity}");
      if (index != -1) {
        if (product.quantity <= 0) {
          await _repository.deleteProductById(cartProducts[index].id ?? -1);
          cartProducts.removeAt(index);
        } else {
          cartProducts[index].quantity = product.quantity;
          await _repository.updateCart(cartProducts[index]);
        }
      } else {
        ProductModel prod = product;
        prod.quantity = 1;
        cartProducts.add(prod);
        await _repository.insertCartProduct(prod);
      }

      getTotalPrice();

      update();
      log("cart updated  ${cartProducts.length}");
    } catch (e) {
      log("Error update cart $e");
      update();
    }
  }

  Future placeOrder() async {
    try {
      isButtonLoading = true;
      update();

      final order = OrderModel(
        id: 'NC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        products: List.unmodifiable(cartProducts),
        status: OrderStatus.ordered,
        createdAt: DateTime.now(),
        total: totalPrice / 100,
      );
      // final orders = [order, ...state.orders];
      OrderRepository.instance.insertOrder(order);
      log("Order placed");
      clearCart();
      isButtonLoading = false;
      update();
      openDialogBox();
    } catch (e, stackTree) {
      isButtonLoading = false;
      update();
      log("Error place order $e ,$stackTree");
    }
  }

  Future<dynamic> openDialogBox() {
    return Get.dialog(
      barrierDismissible: false,

      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        child: Container(
          // height: Get.height * 0.4,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 30,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Order placed successfully.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                  color: CustomColors.textColor,
                ),
              ),
              CustomButton(
                label: "Home",
                onPressed: () {
                  UserModel? user = CommonServices().getUserDetails();
                  if (user?.userType == UserType.dealer) {
                    Get.offAll(() => const DelearDashboard());
                  } else if (user?.userType == UserType.customer) {
                    Get.offAll(() => const CustomerDashboard());
                  } else {
                    Get.offAll(() => const SplashScreen());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clearCart() async {
    try {
      cartProducts.clear();
      totalPrice = 0;
      await _repository.deleteCart();
      update();
      log("cart cleared");
    } catch (e) {
      log("Error clear cart $e");
    }
  }
}
