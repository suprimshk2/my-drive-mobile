import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';

class HalfRoundedButtonWidget extends ButtonWidget {
  HalfRoundedButtonWidget({
    Key? key,
    required BuildContext context,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    Widget? child,
    String? loadingMsg,
    Color? textColor,
    Color? backgroundColor,
  }) : super(
          fontSize: 20,
          key: key,
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          enabled: enabled,
          height: Dimens.spacing_64,
          child: child,
          loadingMsg: loadingMsg,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.spacing_32),
              topRight: Radius.circular(Dimens.spacing_32)),
          backgroundColor: backgroundColor ??
              Theme.of(context).extension<AppColorExtension>()!.primary.main,
          textColor: textColor ??
              Theme.of(context).extension<AppColorExtension>()!.gray.strong,
        );
}
