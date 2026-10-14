import 'package:assessment/features/cart/controllers/cart_controller.dart';
import 'package:assessment/features/cart/views/cart_screen.dart';
import 'package:assessment/features/categories/controllers/categories_controller.dart';
import 'package:assessment/features/categories/views/horizontal_product_tile.dart';
import 'package:assessment/features/products/models/category_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginated_list/paginated_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }
    if (!Get.isRegistered<CategoriesController>()) {
      Get.lazyPut(() => CategoriesController(), fenix: true);
    }

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CategoriesController>().getProductsByCategory(
        category: widget.category.name ?? "",
        index: 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name ?? ""),
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
        ],
      ),
      body: GetBuilder<CategoriesController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const CustomLoading();
          }
          if (controller.error) {
            return Center(
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Something went wrong!"),
                  CustomButton(
                    label: "Retry",
                    onPressed: () {
                      controller.getProductsByCategory(
                        category: widget.category.name ?? "",
                        index: 0,
                      );
                    },
                  ),
                ],
              ),
            );
          }

          if (controller.products.isEmpty) {
            return const Center(
              child: const Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Coming Soon!"),
                  Text("Untill explore other categories!"),
                ],
              ),
            );
          }

          return PaginatedList(
            items: controller.products,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
            isLastPage: controller.isLastProduct,
            isRecentSearch: false,
            loadingIndicator: const Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            onLoadMore: (index) {
              controller.getProductsByCategory(
                category: widget.category.name ?? "",
                index: index,
              );
            },
            builder: (conxt, index) {
              if (index >= controller.products.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final product = controller.products[index];

              return HorizontalProductTile(product: product);
            },
          );
        },
      ),
    );
  }
}
