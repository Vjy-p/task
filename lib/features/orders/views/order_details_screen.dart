import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/views/order_track.dart';
import 'package:assessment/features/products/models/product_model.dart';
import 'package:assessment/features/products/views/product_details_screen.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/glass_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          spacing: 10,
          children: [
            rowTile(label: "Order Id", value: order.id),
            rowTile(
              label: "Created At",
              value: DateFormat("dd-MMM-yyyy").format(order.createdAt),
            ),
            rowTile(label: "Order Id", value: order.id),
            rowTile(label: "Products", value: order.products.length.toString()),
            rowTile(label: "Total", value: order.total.toStringAsFixed(2)),
            rowTile(label: "Estimated delivery", value: "Tomorrow"),
            const SizedBox(height: 10),
            GlassCard(
              padding: EdgeInsetsGeometry.zero,
              child: ExpansionTile(
                title: const Text("Track"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(16),
                ),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                children: [AnimatedOrderTracker(order: order)],
              ),
            ),
            const SizedBox(height: 10),
            productsWidget(),
          ],
        ),
      ),
    );
  }

  Widget rowTile({required String label, required String value}) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: CustomColors.greyColor),
          ),
        ),
        const Text(":"),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: CustomColors.textColor2),
          ),
        ),
      ],
    );
  }

  Widget productsWidget() {
    return GlassCard(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: order.products.length,
        physics: const NeverScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return productTile(context: context, product: order.products[index]);
        },
      ),
    );
  }

  Widget productTile({
    required BuildContext context,
    required ProductModel product,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialButton(
        onPressed: () {
          Get.to(() => ProductDetailsScreen(product: product));
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.fromLTRB(2, 12, 12, 12),
        // padding: EdgeInsets.zero,
        elevation: 0,
        // color: CustomColors.lightColor.withValues(alpha: 0.1),
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                // child: CarouselView.builder(
                //   itemExtent: 200,
                //   itemBuilder: (context, index) {
                //     return CachedNetworkImage(
                //       imageUrl: product.images[index],
                //     );
                //   },
                // ),
                child: Container(
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
              ),
              Expanded(
                flex: 8,
                child: Column(
                  spacing: 6,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.textColor,
                      ),
                    ),

                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            product.price?.toString() ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: CustomColors.textColor2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Quantity : ${product.quantity}",
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.textColor2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
