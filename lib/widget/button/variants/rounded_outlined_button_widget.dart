import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import '../button_widget.dart';

class RoundedOutlinedButtonWidget extends StatelessWidget {
  const RoundedOutlinedButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.child,
    this.loadingMsg,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
    this.borderColor,
    this.borderWidth,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? child;
  final String? loadingMsg;
  final Color? textColor;
  final Color? backgroundColor;
  final double? fontSize;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ButtonWidget(
      fontSize: fontSize,
      padding: padding,
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      loadingMsg: loadingMsg,
      borderRadius: BorderRadius.circular(50),
      needBorder: true,
      borderColor: borderColor,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      textColor: textColor ?? appColors.textPrimary,
      borderWidth: borderWidth,
      child: child,
    );
  }
}
