import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/shared/enum/common.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:flutter/material.dart';

import '../button_widget.dart';

class RoundedFilledButtonWidget extends ButtonWidget {
  RoundedFilledButtonWidget({
    Key? key,
    required BuildContext context,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    Widget? child,
    String? loadingMsg,
    ButtonStyle? buttonStyle,
    Color? textColor,
    Color? backgroundColor,
    Widget? icon,
  }) : super(
          key: key,
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          enabled: enabled,
          child: child,
          loadingMsg: loadingMsg,
          borderRadius: BorderRadius.circular(
            Dimens.radius_large,
          ),
          textColor: textColor,
          backgroundColor: getBackgroundColor(backgroundColor, context),
          icon: icon,
        );
}

Color getBackgroundColor(Color? backgroundColor, BuildContext context) {
  final color = Theme.of(context).extension<AppColorExtension>()!.primary.main;

  return dotenv.env['FLAVOR'] == FLAVOR.Holista
      ? color
      : backgroundColor ?? color;
}
