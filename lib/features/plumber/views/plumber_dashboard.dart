import 'package:assessment/features/notifications/views/notifications_screen.dart';
import 'package:assessment/features/plumber/views/activities_screen.dart';
import 'package:assessment/features/plumber/views/plumber_home_screen.dart';
import 'package:assessment/features/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';

class PlumberDashboard extends StatefulWidget {
  const PlumberDashboard({super.key, this.index});
  final int? index;

  @override
  State<PlumberDashboard> createState() => _PlumberDashboardState();
}

class _PlumberDashboardState extends State<PlumberDashboard> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index ?? 0;
  }

  @override
  void didUpdateWidget(covariant PlumberDashboard oldWidget) {
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
              ? "Activities"
              : "Dashboard",
          style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.6),
        ),
      ),
      body: IndexedStack(
        index: index,
        children: const [
          PlumberHomeScreen(),
          ActivitiesScreen(),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Home',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.grid_view_outlined),
          //   selectedIcon: Icon(Icons.grid_view),
          //   label: 'Products',
          // ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Activities',
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
