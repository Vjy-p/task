import 'package:assessment/features/cart/views/cart_screen.dart';
import 'package:assessment/features/categories/views/categories_screen.dart';
import 'package:assessment/features/notifications/views/notifications_screen.dart';
import 'package:assessment/features/orders/views/orders_screen.dart';
import 'package:assessment/features/profile/views/profile_screen.dart';
import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key, this.index});
  final int? index;

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index ?? 0;
  }

  @override
  void didUpdateWidget(covariant CustomerDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != null && widget.index != oldWidget.index) {
      setState(() {
        index = widget.index!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ProfileScreen(
          onSelectTab: (newIndex) {
            setState(() {
              index = newIndex;
            });
          },
        ),
      ),
      appBar: AppBar(
        title: Text(
          index == 2
              ? "Notifications"
              : index == 1
              ? "Orders"
              : "Categories",
          style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.6),
        ),
        actionsPadding: const EdgeInsets.only(right: 6),
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
      body: IndexedStack(
        index: index,
        children: const [
          CategoriesScreen(),
          OrdersScreen(),
          NotificationsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        // backgroundColor: CustomColors.primaryColor.withValues(alpha: .96),
        // indicatorColor: CustomColors.primaryColor.withValues(alpha: .12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Categories',
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.person_outline),
          //   selectedIcon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}
