import 'dart:ui';

import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: CustomColors.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: CustomColors.primaryColor.withValues(alpha: .1),
            ),
            boxShadow: [
              BoxShadow(
                color: CustomColors.primaryColor.withValues(alpha: .2),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
    return onTap == null
        ? content
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: content,
          );
  }
}
