import 'package:assessment/features/orders/controllers/order_controller.dart';
import 'package:assessment/features/orders/models/order_model.dart';
import 'package:assessment/features/orders/models/order_status.dart';
import 'package:assessment/features/orders/views/order_details_screen.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:assessment/utils/custom_loading.dart';
import 'package:assessment/utils/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.orders.isEmpty) controller.loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(
        init: OrderController(),
        builder: (controller) {
          final orders = controller.orders;
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
                          controller.loadOrders();
                        },
                      ),
                    ],
                  ),
                )
              : orders.isEmpty
              ? const Center(child: Text('No orders yet'))
              : RefreshIndicator(
                  onRefresh: () async {
                    controller.loadOrders();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      OrderModel o = orders[index];
                      return GlassCard(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsScreen(order: o),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '#${o.id}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                _Status(status: o.status),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '${o.products.length} products · \$${o.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.textColor2,
                              ),
                            ),
                            const SizedBox(height: 14),
                            LinearProgressIndicator(
                              value: o.status == OrderStatus.delivered
                                  ? 1
                                  : o.status == OrderStatus.outForDelivery
                                  ? .8
                                  : o.status == OrderStatus.dispatched
                                  ? .5
                                  : 0.1,
                              minHeight: 3,
                              color: CustomColors.blueColor,
                              backgroundColor: CustomColors.greyColor,
                            ),
                            const SizedBox(height: 10),
                            if (o.status != OrderStatus.delivered)
                              Text(
                                'Estimated delivery · Tomorrow',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CustomColors.textColor3,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 20);
                    },
                  ),
                );
        },
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final OrderStatus status;
  const _Status({required this.status});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: CustomColors.primaryColor.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: CustomColors.primaryColor.withValues(alpha: .35),
      ),
    ),
    child: Text(
      status.name,
      style: TextStyle(
        fontSize: 13,
        color: CustomColors.textColor2,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    ),
  );
}
