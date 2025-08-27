import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import '../button_widget.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
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
    this.width,
    this.needBorder = false,
    this.height,
    this.textDecoration = TextDecoration.none,
    this.padding,
    this.minSize,
    this.tapTargetSize,
    this.overlayColor,
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
  final double? width;
  final bool needBorder;
  final double? height;
  final TextDecoration textDecoration;
  final EdgeInsets? padding;
  final Size? minSize;
  final MaterialTapTargetSize? tapTargetSize;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ButtonWidget(
      height: height,
      width: width,
      needBorder: needBorder,
      fontSize: fontSize,
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
      loadingMsg: loadingMsg,
      borderRadius: BorderRadius.circular(50),
      backgroundColor: AppColors.transparent,
      textDecoration: textDecoration,
      textColor: textColor ?? appColors.textPrimary,
      minSize: minSize ?? Size.zero,
      tapTargetSize: tapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      overlayColor: overlayColor ?? appColors.gray.soft,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: Dimens.spacing_extra_small,
            vertical: Dimens.spacing_6,
          ),
      child: child,
    );
  }
}
