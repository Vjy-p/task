import 'dart:math';

import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/cart/controllers/cart_controller.dart';
import 'package:assessment/features/cart/views/cart_screen.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/wishlist/controllers/wishlist_controller.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final whishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());
    final user = CommonServices().getUserDetails();
    debugPrint("user type ${user?.userType}");
    final image =
        product.thumbnail ??
        (product.images.isNotEmpty ? product.images.first : '');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 22,
              color: CustomColors.primaryColor,
            ),
          ),
          Obx(() {
            bool saved = whishlistController.savedIds.contains(product.id);
            return InkWell(
              onTap: () {
                whishlistController.toggleSaved(product: product);
              },
              child: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? CustomColors.favColor : CustomColors.whiteColor,
                size: 22,
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: bottomBarWidget(context: context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: image.isEmpty
                      ? ColoredBox(color: CustomColors.lightColor)
                      : Image.network(image, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              product.brand ?? '',
              style: TextStyle(fontSize: 14, color: CustomColors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              product.title ?? '',
              style: TextStyle(fontSize: 18, color: CustomColors.textColor2),
            ),
            const SizedBox(height: 10),

            if (user?.userType == UserType.dealer)
              Text(
                "Quantity : ${Random().nextInt(1000)}",
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.textColor3,
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: CustomColors.amberColor,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  '${product.rating ?? 0}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 14),
                Text(
                  '${product.reviews.length} reviews',
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.textColor3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '\$${(product.price ?? 0).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.textColor3,
              ),
            ),

            const SizedBox(height: 22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    color: CustomColors.textColor3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.description ?? 'Precision-engineered product with premium materials and a refined user experience.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    color: CustomColors.textColor3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.local_shipping_outlined,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text('Fast delivery'),
                  subtitle: Text(
                    product.shippingInformation ??
                        'Free delivery on eligible orders',
                  ),
                ),
                ListTile(
                  tileColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.autorenew,
                    color: CustomColors.lightColor,
                  ),
                  title: const Text('Easy returns'),
                  subtitle: Text(
                    product.returnPolicy ?? '30-day return policy',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget bottomBarWidget({required BuildContext context}) {
    return BottomAppBar(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GetBuilder<CartController>(
        builder: (controller) {
          ProductModel? cartItem;
          try {
            cartItem = controller.cartProducts.firstWhere(
              (e) => e.id == product.id,
            );
          } catch (_) {
            cartItem = null;
          }

          return cartItem != null
              ? Card(
                  margin: EdgeInsets.zero,
                  color: CustomColors.lightColor.withValues(alpha: 0.6),
                  child: Row(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                product.quantity = cartItem!.quantity - 1;
                                controller.updateProduct(product: product);
                              },
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                      ),
                      // state.status == CartStatus.loading
                      //     ? const Center(
                      //         child: CircularProgressIndicator.adaptive(),
                      //       )
                      //     :
                      Text(
                        cartItem.quantity <= 0 ? '1' : '${cartItem.quantity}',
                      ),
                      IconButton(
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                product.quantity = cartItem!.quantity + 1;
                                controller.updateProduct(product: product);
                              },
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                      ),
                    ],
                  ),
                )
              : controller.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'ADD TO CART',
                        icon: Icons.shopping_cart_outlined,
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                product.quantity = 1;
                                controller.updateProduct(product: product);
                              },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GlassCard(
                        padding: EdgeInsetsGeometry.zero,
                        child: CustomButton(
                          label: 'BUY NOW',
                          icon: Icons.shopping_cart_checkout_rounded,
                          onPressed: controller.isLoading
                              ? null
                              : () {
                                  product.quantity = 1;
                                  controller.updateProduct(product: product);
                                  Get.to(() => const CartScreen());
                                },
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
