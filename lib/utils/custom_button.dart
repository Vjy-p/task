import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final FontStyle? fontStyle;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? buttonColor;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.buttonColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      color: buttonColor ?? CustomColors.primaryColor,
      disabledColor: CustomColors.lightColor,
      disabledTextColor: CustomColors.primaryColor.withValues(alpha: 0.1),
      elevation: elevation,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.comfortable,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: textColor ?? CustomColors.whiteColor),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor ?? CustomColors.whiteColor,
              fontSize: fontSize ?? 14,
              fontStyle: fontStyle,
              fontWeight: fontWeight ?? FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
