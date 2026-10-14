import 'package:assessment/features/plumber/controllers/plumber_controller.dart';
import 'package:assessment/features/plumber/models/assignment_model.dart';
import 'package:assessment/features/plumber/views/widgets/activity_tile.dart';
import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ActivitiesScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  List<String> tabs = [
    'All',
    'Assigned',
    'In Progress',
    'Pending',
    'Completed',
  ];

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlumberController>(
      builder: (controller) {
        List<AssignmentModel> assigned = List.from(
          controller.assignments.where(
            (a) => a.status == 'Assigned' || a.status == 'Pending',
          ),
        );
        List<AssignmentModel> progress = List.from(
          controller.assignments.where((a) => a.status == 'In Progress'),
        );
        List<AssignmentModel> pending = List.from(
          controller.assignments.where((a) => a.status == 'Pending'),
        );
        List<AssignmentModel> completed = List.from(
          controller.assignments.where((a) => a.status == 'Completed'),
        );
        return Scaffold(
          body: Column(
            spacing: 10,
            children: [
              TabBar(
                controller: tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: CustomColors.primaryColor,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: CustomColors.greyColor,
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                tabs: List.generate(tabs.length, (index) {
                  return Tab(text: tabs[index]);
                }),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    tabViewWidget(activities: controller.assignments),
                    tabViewWidget(activities: assigned),
                    tabViewWidget(activities: progress),
                    tabViewWidget(activities: pending),
                    tabViewWidget(activities: completed),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget tabViewWidget({required List<AssignmentModel> activities}) {
    return activities.isEmpty
        ? Center(
            child: Text(
              "No Activities",
              style: TextStyle(
                fontSize: 18,
                color: CustomColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : ListView.separated(
            itemCount: activities.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemBuilder: (context, index) {
              return ActivityTile(
                activity: activities[index],
                showStatus: true,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 0),
          );
  }
}

// class ActivitiesScreen extends StatefulWidget { const ActivitiesScreen({super.key}); @override State<ActivitiesScreen> createState() => _ActivitiesScreenState(); }
// class _ActivitiesScreenState extends State<ActivitiesScreen> {
//   String filter = 'All';
//   @override Widget build(BuildContext context) { final filtered = demoActivities.where((a) => filter == 'All' || a.status == filter).toList(); return Scaffold(appBar: AppBar(title: const Text('My Orders / Activities')), body: Column(children: [SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: Row(children: ['All', 'Assigned', 'In Progress', 'Completed', 'Pending'].map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f))).toList())), Expanded(child: filtered.isEmpty ? const EmptyState(icon: Icons.assignment_turned_in_outlined, title: 'No activities', subtitle: 'There are no activities in this status.') : ListView(padding: const EdgeInsets.all(16), children: [...filtered.map((a) => _ActivityListCard(activity: a)), const InfoBanner(text: 'Activity list uses sample data. Connect your assigned-activities API for production.')]))]), bottomNavigationBar: NavigationBar(selectedIndex: 2, onDestinationSelected: (i) { if (i == 0) context.go('/home'); if (i == 1) context.go('/products'); if (i == 3) context.go('/profile'); }, destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'), NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Products'), NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Activities'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile')])); }
// }
