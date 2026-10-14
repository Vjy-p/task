import 'dart:developer';

import 'package:assessment/features/notifications/data/notifications_services.dart';
import 'package:assessment/features/notifications/models/notification_model.dart';
import 'package:get/state_manager.dart';

class NotificationController extends GetxController {
  final NotificationsServices api = NotificationsServices();
  static const int _limit = 10;

  bool isLoading = false;
  bool error = false;
  List<NotificationModel> notifications = [];
  bool isLastNotification = true;

  @override
  void onInit() {
    loadNotifications(index: 0);
    super.onInit();
  }

  Future<void> loadNotifications({required int index}) async {
    try {
      isLoading = true;
      error = false;
      update();
      notifications = List.generate(
        9,
        (index) => NotificationModel(
          text: "Order Placed",
          id: "12344sffd",
          title: "Order",
          type: 1,
          date: DateTime.now(),
        ),
      );
      // List<NotificationModel> tempNotifications = [];

      // final resp = await api.loadNotifications(index: index, limit: _limit);

      // if (resp['notifications'] != null) {
      //   // final Map<String, dynamic> data = jsonDecode(resp);

      //   final List respList = resp['notifications'] ?? [];

      //   tempNotifications = respList
      //       .map((e) => NotificationModel.fromJson(e))
      //       .toList();
      //   notifications.addAll(tempNotifications);
      //   if (tempNotifications.length < _limit) {
      //     isLastNotification = true;
      //   }
      // }

      isLoading = false;
      error = false;
      update();
    } catch (e, stackTree) {
      isLoading = false;
      error = true;
      update();
      log("error load notifications $e $stackTree");
    }
  }
}
