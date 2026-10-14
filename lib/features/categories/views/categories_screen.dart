import 'package:assessment/features/categories/controllers/categories_controller.dart';
import 'package:assessment/features/categories/views/category_screen.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:assessment/utils/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CategoriesController>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CategoriesController>(
        init: CategoriesController(),
        builder: (controller) {
          return controller.isLoading
              ? const CustomLoading()
              : controller.error
              ? Center(
                  child: Column(
                    spacing: 30,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Something went wrong!"),
                      CustomButton(
                        label: "Retry",
                        onPressed: () {
                          controller.getCategories();
                        },
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  itemCount: controller.categories.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    // mainAxisExtent: 50,
                    childAspectRatio: 2,
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 50),
                  itemBuilder: (context, index) {
                    return GlassCard(
                      padding: EdgeInsetsGeometry.zero,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                        onPressed: () {
                          Get.to(
                            () => CategoryScreen(
                              category: controller.categories[index],
                            ),
                          );
                        },
                        // color: AppColors.text.withValues(alpha: 0.6),
                        padding: EdgeInsets.zero,
                        child: Container(
                          alignment: AlignmentGeometry.center,
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: CachedNetworkImageProvider(
                          //       controller.categories[index].url ?? "",
                          //     ),
                          //   ),
                          // ),
                          child: Text(
                            controller.categories[index].name ?? "",
                            style: TextStyle(
                              color: CustomColors.textColor2,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
