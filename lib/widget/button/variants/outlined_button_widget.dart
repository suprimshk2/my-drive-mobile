import 'package:flutter/material.dart';

import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import '../button_widget.dart';

class OutlinedButtonWidget extends ButtonWidget {
  OutlinedButtonWidget({
    Key? key,
    required BuildContext context,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    Widget? child,
    String? loadingMsg,
    double? fontSize,
    Color? borderColor,
    Color? textColor,
  }) : super(
          key: key,
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          enabled: enabled,
          child: child,
          loadingMsg: loadingMsg,
          needBorder: true,
          backgroundColor: AppColors.transparent,
          borderColor: borderColor ??
              Theme.of(context).extension<AppColorExtension>()!.primary.bold,
          textColor: textColor ??
              Theme.of(context).extension<AppColorExtension>()!.primary.bold,
          borderRadius: BorderRadius.circular(
            Dimens.radius_small,
          ),
          fontSize: fontSize,
        );
}
