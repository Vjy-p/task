import 'package:assessment/features/categories/views/category_screen.dart';
import 'package:assessment/features/products/controllers/product_controller.dart';
import 'package:assessment/features/products/views/product_card.dart';
import 'package:assessment/features/products/views/product_details_screen.dart';
import 'package:assessment/features/wishlist/controllers/wishlist_controller.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: GetBuilder<ProductController>(
      init: ProductController(),
      builder: (controller) {
        return controller.isLoading
            ? const CustomLoading()
            : controller.error
            ? Center(
                child: Column(
                  spacing: 40,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Something went wrong!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryColor,
                      ),
                    ),
                    CustomButton(
                      label: "Retry",
                      onPressed: () {
                        controller.loadData();
                      },
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 60,
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      clipBehavior: Clip.none,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        itemBuilder: (context, index) {
                          // return GlassCard(
                          //   padding: EdgeInsetsGeometry.all(10),
                          //   child: Text(controller.categories[index].name ?? ""),
                          // );
                          return MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(16),
                            ),
                            color: CustomColors.lightColor.withValues(
                              alpha: 0.7,
                            ),
                            onPressed: () {
                              Get.to(
                                () => CategoryScreen(
                                  category: controller.categories[index],
                                ),
                              );
                            },
                            padding: const EdgeInsetsGeometry.all(10),
                            child: Text(
                              controller.categories[index].name ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: CustomColors.textColor3,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.sort),
                            label: Text(
                              'SORT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: CustomColors.textColor3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((_, i) {
                        final p = controller.products[i];
                        return GetBuilder<WishlistController>(
                          init: Get.isRegistered<WishlistController>()
                              ? null
                              : WishlistController(),
                          builder: (controller) => ProductCard(
                            product: p,
                            onTap: () =>
                                Get.to(() => ProductDetailsScreen(product: p)),
                          ),
                        );
                      }, childCount: controller.products.length),
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
              );
      },
    ),
  );
}
