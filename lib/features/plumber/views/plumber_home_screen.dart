import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/plumber/controllers/plumber_controller.dart';
import 'package:assessment/features/plumber/views/plumber_dashboard.dart';
import 'package:assessment/features/plumber/views/widgets/activity_tile.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:assessment/utils/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlumberHomeScreen extends StatelessWidget {
  const PlumberHomeScreen({super.key});

  UserModel? get user => CommonServices().getUserDetails();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlumberController>(
      init: PlumberController(),
      builder: (controller) {
        final assigned = controller.assignments
            .where((a) => a.status == 'Assigned' || a.status == 'Pending')
            .length;
        final progress = controller.assignments
            .where((a) => a.status == 'In Progress')
            .length;
        final completed = controller.assignments
            .where((a) => a.status == 'Completed')
            .length;
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => const PlumberDashboard(index: 2));
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: CustomColors.primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: CustomColors.whiteColor,
                        child: const Icon(
                          Icons.person,
                          size: 32,
                          color: const Color(0xFF145DA0),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${user?.name ?? ''}',
                              style: TextStyle(
                                color: CustomColors.whiteColor,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Plumber ID: PLB1001',
                              style: TextStyle(
                                color: CustomColors.whiteColor.withValues(
                                  alpha: .85,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Here is your work summary',
                              style: TextStyle(
                                color: CustomColors.whiteColor.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: CustomColors.whiteColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsetsGeometry.all(10),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    summaryTile(
                      icon: Icons.assignment_outlined,
                      count: '$assigned',
                      label: 'Assigned / Pending',
                      color: CustomColors.blueColor,
                    ),
                    summaryTile(
                      icon: Icons.timelapse_rounded,
                      count: '$progress',
                      label: 'In Progress',
                      color: CustomColors.amberColor,
                    ),
                    summaryTile(
                      icon: Icons.check_circle_outline,
                      count: '$completed',
                      label: 'Completed',
                      color: CustomColors.greenColor,
                    ),
                    // summaryTile(
                    //   icon: Icons.inventory_2_outlined,
                    //   count: '${demoProducts.where((p) => p.canPurchase).length}',
                    //   label: 'Available products',
                    //   color: const Color(0xFF805AD5),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Quick actions',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.offAll(
                      () => const PlumberDashboard(index: 1),
                      // preventDuplicates: false,
                    ),
                    child: const Text('View all'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: quickAction(
                      icon: Icons.inventory_2_outlined,
                      title: 'Browse Products',
                      subtitle: 'Find required materials',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: quickAction(
                      icon: Icons.assignment_outlined,
                      title: 'My Activities',
                      subtitle: 'View assigned work',
                      onTap: () => Get.offAll(() => const PlumberDashboard(index: 1)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: const Text(
                      'Upcoming activities',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Get.offAll(() => const PlumberDashboard(index: 1)),
                    child: const Text('See all'),
                  ),
                ],
              ),
              ...controller.assignments
                  .where((a) => a.status != 'Completed')
                  .take(3)
                  .map((a) => ActivityTile(activity: a)),
            ],
          ),
        );
      },
    );
  }

  Widget summaryTile({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomColors.whiteColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: CustomColors.textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: const Color(0xFF1677E8)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
