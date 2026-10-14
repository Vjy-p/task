import 'package:assessment/features/notifications/models/notification_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatefulWidget {
  const NotificationTile({super.key, required this.notification});
  final NotificationModel notification;

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.lightColor.withValues(alpha: 0.1),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_outlined, size: 22),
            Expanded(
              child: Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.notification.title ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (widget.notification.date != null)
                        Text(
                          DateFormat(
                            "dd-MMM-yyyy",
                          ).format(widget.notification.date ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    widget.notification.text ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.textColor2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
