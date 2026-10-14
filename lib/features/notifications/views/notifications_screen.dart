import 'package:assessment/features/notifications/controllers/notification_controller.dart';
import 'package:assessment/features/notifications/views/notification_tile.dart';
import 'package:assessment/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginated_list/paginated_list.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : controller.error
              ? Center(
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Something went wrong!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomButton(
                        label: "Retry",
                        onPressed: () {
                          controller.loadNotifications(index: 0);
                        },
                      ),
                    ],
                  ),
                )
              : PaginatedList(
                  items: controller.notifications,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                  isLastPage: controller.isLastNotification,
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
                    controller.loadNotifications(index: index);
                  },
                  builder: (conxt, index) {
                    final notification = controller.notifications[index];
                    return NotificationTile(notification: notification);
                  },
                ),
        );
      },
    );
  }
}
