import 'package:assessment/features/plumber/models/assignment_model.dart';
import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.activity,
    this.showStatus = false,
  });
  final AssignmentModel activity;
  final bool showStatus;
  @override
  Widget build(BuildContext context) => Card(
    color: CustomColors.amberColor.withValues(alpha: 0.1),
    margin: const EdgeInsets.only(bottom: 10),
    child: Stack(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: CustomColors.lightColor.withValues(alpha: 0.3),
            child: const Icon(Icons.handyman_outlined),
          ),
          title: Text(
            activity.title ?? "",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              '${activity.customerName ?? ""} • ${activity.schedule}',
              maxLines: 2,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        if (showStatus)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.lightColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                activity.status ?? "",
                style: TextStyle(
                  fontSize: 12,
                  color: CustomColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
