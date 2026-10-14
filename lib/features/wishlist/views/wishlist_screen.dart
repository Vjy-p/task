import 'package:assessment/features/products/views/product_card.dart';
import 'package:assessment/features/products/views/product_details_screen.dart';
import 'package:assessment/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<WishlistController>()) {
        final ctrl = Get.find<WishlistController>();
        ctrl.loadWhishList();
        ctrl.loadWhishListIds();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishlistController>(
      init: Get.isRegistered<WishlistController>()
          ? null
          : WishlistController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text("Saved Products")),
          body: CustomScrollView(
            slivers: [
              if (controller.savedIds.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No saved products yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((_, i) {
                      final p = controller.wishlistProducts[i];
                      return ProductCard(
                        product: p,
                        onTap: () {
                          Get.to(() => ProductDetailsScreen(product: p));
                        },
                      );
                    }, childCount: controller.wishlistProducts.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: .64,
                        ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
