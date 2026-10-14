import 'package:assessment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void fieldFocusChange({
  required BuildContext context,
  required FocusNode currentFocus,
  FocusNode? nextFocus,
}) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.currentFocus,
    this.nextFocus,
    this.borderColor,
    this.borderRadius,
    this.textColor,
    this.keyboardType,
    this.enable = true,
    this.inputAction,
    this.isEmail = false,
    this.isPinCode = false,
    this.isMobileNumber = false,
    this.maxLines,
    this.maxCount = 200,
    this.validate = true,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String label;
  final Icon icon;
  final TextEditingController controller;
  final FocusNode currentFocus;
  final FocusNode? nextFocus;
  final Color? borderColor;
  final double? borderRadius;
  final Color? textColor;
  final TextInputType? keyboardType;
  final bool enable;
  final TextInputAction? inputAction;
  final bool isEmail;
  final bool isPinCode;
  final bool isMobileNumber;
  final int? maxLines;
  final int? maxCount;
  final bool validate;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: textColor ?? CustomColors.textColor,
          ),
        ),
        TextFormField(
          keyboardType: isPinCode || isMobileNumber
              ? const TextInputType.numberWithOptions()
              : keyboardType ?? TextInputType.text,
          style: TextStyle(color: textColor ?? CustomColors.textColor),
          controller: controller,
          focusNode: currentFocus,
          maxLines: isPinCode || isMobileNumber ? 1 : maxLines,
          maxLength: isPinCode
              ? 6
              : isMobileNumber
              ? 10
              : maxCount,
          textCapitalization: isPinCode || isMobileNumber
              ? TextCapitalization.none
              : TextCapitalization.words,
          textInputAction:
              inputAction ??
              (nextFocus != null ? TextInputAction.next : TextInputAction.done),
          inputFormatters: isPinCode || isMobileNumber
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          decoration: InputDecoration(
            enabled: enable,
            isDense: true,
            counterText: "",
            visualDensity: VisualDensity.comfortable,
            hintText: "Enter $label",
            hintStyle: TextStyle(
              color: textColor ?? CustomColors.textColor.withValues(alpha: 0.6),
            ),
            prefixIcon: icon,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? CustomColors.textColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? CustomColors.textColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? CustomColors.textColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? CustomColors.textColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? CustomColors.textColor,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomColors.redColor),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            filled: true,
            // fillColor: CustomColors.lightColor,
          ),
          onChanged: onChanged,
          onFieldSubmitted:
              onFieldSubmitted ??
              (value) {
                fieldFocusChange(
                  context: context,
                  currentFocus: currentFocus,
                  nextFocus: nextFocus,
                );
              },
          onTapOutside: (event) {
            if (FocusManager.instance.primaryFocus!.hasFocus) {
              currentFocus.unfocus();
            }
          },
          validator: validate
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return label.toLowerCase().contains("Enter")
                        ? "Enter ${label.substring(5).toLowerCase()}"
                        : "Enter ${label.toLowerCase()}";
                    // } else if (isEmail) {
                    //   return GetUtils.isEmail(value.toString())
                    //       ? null
                    //       : "Enter Correct E-mail";
                  } else if (isEmail &&
                      !RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                    return 'Enter a valid email address';
                  } else if (isPinCode && value.length < 6) {
                    return "Enter correct pin code";
                  } else if (isMobileNumber && value.length < 10) {
                    return "Enter correct mobile number";
                  } else {
                    return null;
                  }
                }
              : null,
        ),
      ],
    );
  }
}
