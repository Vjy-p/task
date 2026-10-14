import 'dart:math';

import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/cart/controllers/cart_controller.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/products/views/product_details_screen.dart';
import 'package:assessment/features/wishlist/controllers/wishlist_controller.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class HorizontalProductTile extends StatelessWidget {
  const HorizontalProductTile({super.key, required this.product});
  final ProductModel product;

  static void ensureCartController() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ensureCartController();
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());
    final user = CommonServices().getUserDetails();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialButton(
        onPressed: () {
          Get.to(() => ProductDetailsScreen(product: product));
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.fromLTRB(2.0, 12, 10, 10),
        color: CustomColors.whiteColor.withValues(alpha: 0.7),
        // elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              // child: CarouselView.builder(
              //   itemExtent: 200,
              //   itemBuilder: (context, index) {
              //     return CachedNetworkImage(
              //       imageUrl: product.images[index],
              //     );
              //   },
              // ),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail ?? "",
                      progressIndicatorBuilder: (context, url, progress) {
                        // debugPrint("image url $url");
                        return const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        // debugPrint("image url error $url\n$error");
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                  Obx(() {
                    bool saved = wishlistController.savedIds.contains(
                      product.id,
                    );
                    return Positioned(
                      top: 0,
                      left: 10,
                      child: InkWell(
                        onTap: () {
                          wishlistController.toggleSaved(product: product);
                        },
                        child: Icon(
                          saved ? Icons.favorite : Icons.favorite_border,
                          color: saved
                              ? CustomColors.favColor
                              : CustomColors.greyColor,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? "",
                    style: TextStyle(
                      fontSize: 13,
                      color: CustomColors.textColor,
                    ),
                  ),
                  Text(
                    product.brand ?? "",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 13,
                      color: CustomColors.textColor2,
                    ),
                  ),
                  Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${product.discountPercentage?.toString() ?? ""}%",
                        maxLines: 1,
                      ),
                      Text(
                        product.price?.toString() ?? "",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textColor,
                        ),
                      ),
                      const Spacer(),
                      if (user?.userType == UserType.dealer)
                        Text(
                          "Quantity : ${Random().nextInt(1000)}",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.textColor3,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingBarIndicator(
                        rating: product.rating ?? 0,
                        itemSize: 16,
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rounded,
                          color: CustomColors.amberColor,
                        ),
                      ),
                      const Spacer(),
                      GetBuilder<CartController>(
                        builder: (controller) {
                          ProductModel? cartItem;
                          try {
                            cartItem = controller.cartProducts.firstWhere(
                              (e) => e.id == product.id,
                            );
                          } catch (_) {
                            cartItem = null;
                          }

                          return controller.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : cartItem != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryColor.withValues(
                                      alpha: .12,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CustomColors.primaryColor
                                          .withValues(alpha: .4),
                                    ),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        iconSize: 18,
                                        style: const ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: WidgetStatePropertyAll(
                                            Size(22, 22),
                                          ),
                                          maximumSize: WidgetStatePropertyAll(
                                            Size(24, 24),
                                          ),
                                        ),
                                        onPressed: () {
                                          product.quantity =
                                              (cartItem?.quantity ?? 1) - 1;
                                          controller.updateProduct(
                                            product: product,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                          // color: AppColors.danger,
                                          color: CustomColors.lightColor,
                                        ),
                                      ),
                                      Text(
                                        cartItem.quantity <= 0
                                            ? '1'
                                            : '${cartItem.quantity}',
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        iconSize: 18,
                                        style: const ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: WidgetStatePropertyAll(
                                            Size(22, 22),
                                          ),
                                          maximumSize: WidgetStatePropertyAll(
                                            Size(24, 24),
                                          ),
                                        ),
                                        onPressed: () {
                                          product.quantity =
                                              (cartItem?.quantity ?? 0) + 1;
                                          controller.updateProduct(
                                            product: product,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                          // color: AppColors.success,
                                          color: CustomColors.lightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    product.quantity = 1;
                                    controller.updateProduct(product: product);
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: CustomColors.lightColor.withValues(
                                        alpha: .12,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: CustomColors.lightColor
                                            .withValues(alpha: .4),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: CustomColors.lightColor,
                                      size: 18,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
