import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/cart/controllers/cart_controller.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:assessment/utils/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  UserModel? get user => CommonServices().getUserDetails();

  static void ensureCartController() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }
  }

  // static int ranomNumber = Random().nextInt(1000);

  @override
  Widget build(BuildContext context) {
    ensureCartController();
    return Scaffold(
      appBar: AppBar(title: const Text('SHOPPING CART')),
      body: GetBuilder<CartController>(
        builder: (controller) {
          final items = controller.cartProducts;
          final total = controller.totalPrice;

          return CustomScrollView(
            slivers: [
              if (items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Your cart is empty')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((_, i) {
                      final p = items[i];
                      final image =
                          p.thumbnail ??
                          (p.images.isNotEmpty ? p.images.first : '');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          padding: const EdgeInsetsGeometry.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: SizedBox(
                                    child: image.isEmpty
                                        ? ColoredBox(
                                            color: CustomColors.lightColor,
                                          )
                                        : Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.title ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.textColor2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$${(p.price ?? 0).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: CustomColors.textColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: CustomColors.lightColor
                                                .withValues(alpha: 0.7),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 1,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                style: const ButtonStyle(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  fixedSize:
                                                      WidgetStatePropertyAll(
                                                        Size(20, 20),
                                                      ),
                                                ),
                                                onPressed: () {
                                                  p.quantity--;
                                                  controller.updateProduct(
                                                    product: p,
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  size: 18,
                                                  color:
                                                      CustomColors.primaryColor,
                                                ),
                                              ),
                                              Text(
                                                '${p.quantity}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      CustomColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                style: const ButtonStyle(
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  fixedSize:
                                                      WidgetStatePropertyAll(
                                                        Size(20, 20),
                                                      ),
                                                ),
                                                onPressed: () {
                                                  p.quantity++;
                                                  controller.updateProduct(
                                                    product: p,
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.add_circle_outline,
                                                  size: 18,
                                                  color:
                                                      CustomColors.primaryColor,
                                                ),
                                              ),
                                            ],
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
                      );
                    }, childCount: items.length),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SUBTOTAL",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _Row(
                          label: 'ITEMS',
                          valueLabel:
                              '${items.fold<int>(0, (s, p) => s + p.quantity)}',
                        ),
                        // _Row(
                        //   label: 'Delivery Fee',
                        //   valueLabel: '\$4',
                        //   strong: true,
                        // ),
                        _Row(
                          label: 'TOTAL',
                          valueLabel: '\$${total.toStringAsFixed(2)}',
                          strong: true,
                        ),
                        if (user?.userType == UserType.dealer)
                          checkPayLaterWidget(controller: controller),
                        const SizedBox(height: 16),
                        controller.isButtonLoading
                            ? const CustomLoading()
                            : SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  label: 'PROCEED TO CHECKOUT',
                                  onPressed: () {
                                    controller.placeOrder();
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget checkPayLaterWidget({required CartController controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Credit Payment",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Column(
            children: List.generate(controller.creditPayments.length, (index) {
              return Row(
                children: [
                  Checkbox(
                    shape: const CircleBorder(),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value:
                        controller.selectedCreditPayment ==
                        controller.creditPayments[index],
                    onChanged: (v) {
                      controller.changePayLater(
                        val: controller.creditPayments[index],
                      );
                    },
                  ),
                  Text(
                    "${controller.creditPayments[index]} days",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String? valueLabel;
  final bool strong;
  const _Row({
    required this.label,
    required this.valueLabel,
    this.strong = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const Spacer(),
        if (valueLabel != null)
          Text(
            valueLabel!,
            style: strong
                ? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                : const TextStyle(fontSize: 14),
          ),
      ],
    ),
  );
}
