import 'package:assessment/features/cart/controllers/cart_controller.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/wishlist/controllers/wishlist_controller.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/glass_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());
    final image =
        product.thumbnail ??
        (product.images.isNotEmpty ? product.images.first : '');
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    child: AspectRatio(
                      aspectRatio: .9,
                      child: image.isEmpty
                          ? ColoredBox(color: CustomColors.lightColor)
                          : CachedNetworkImage(
                              imageUrl: image,
                              fit: BoxFit.contain,
                              errorWidget: (_, _, _) => ColoredBox(
                                color: CustomColors.textColor2,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                Obx(() {
                  bool saved = wishlistController.savedIds.contains(product.id);
                  return Positioned(
                    top: 16,
                    right: 12,
                    child: InkWell(
                      onTap: () {
                        wishlistController.toggleSaved(product: product);
                      },
                      child: Icon(
                        saved ? Icons.favorite : Icons.favorite_border,
                        color: saved
                            ? CustomColors.favColor
                            : CustomColors.whiteColor,
                        size: 22,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.title ?? 'Untitled product',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.textColor2,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Text(
                        '\$${(product.price ?? 0).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textColor3,
                        ),
                      ),
                      const Spacer(),
                      GetBuilder<CartController>(
                        builder: (cartController) {
                          ProductModel? cartItem;
                          try {
                            cartItem = cartController.cartProducts.firstWhere(
                              (e) => e.id == product.id,
                            );
                          } catch (_) {
                            cartItem = null;
                          }
                          return cartController.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : cartItem != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryColor.withValues(
                                      alpha: .3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: CustomColors.lightColor.withValues(
                                        alpha: .4,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    spacing: 2,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        style: const ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () {
                                          product.quantity =
                                              cartItem!.quantity - 1;
                                          cartController.updateProduct(
                                            product: product,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                          // color: AppColors.danger,
                                          color: CustomColors.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        cartItem.quantity <= 0
                                            ? '1'
                                            : '${cartItem.quantity}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: CustomColors.primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        style: const ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () {
                                          product.quantity =
                                              cartItem!.quantity + 1;
                                          cartController.updateProduct(
                                            product: product,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                          color: CustomColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    product.quantity = 1;
                                    cartController.updateProduct(
                                      product: product,
                                    );
                                  },
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: CustomColors.lightColor.withValues(
                                        alpha: .5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: CustomColors.lightColor
                                            .withValues(alpha: .4),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: CustomColors.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
