import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

import 'package:mydrivenepal/shared/util/util.dart';

import 'package:mydrivenepal/widget/info/info_container.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showToast(BuildContext context, String message,
    {bool isSuccess = true, int duration = 1000}) {
  showTopSnackBar(
    Overlay.of(context),
    isSuccess
        ? InfoContainer(
            title: message,
            type: InfoType.success,
          )
        : InfoContainer(
            title: message,
            type: InfoType.error,
          ),
    displayDuration: Duration(milliseconds: duration),
  );
}

SnackBar showSnackBar(
  BuildContext context,
  String message, {
  bool isSuccess = false,
  String actionText = "",
  VoidCallback? onPressed,
}) {
  final appColors = context.appColors;

  return SnackBar(
    backgroundColor:
        isSuccess ? appColors.success.subtle : appColors.error.subtle,
    padding: const EdgeInsets.all(Dimens.spacing_8),
    duration:
        isSuccess ? const Duration(seconds: 6) : const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    elevation: 1,
    action: actionText.isNotEmpty
        ? SnackBarAction(
            label: actionText,
            textColor: appColors.success.main,
            onPressed: onPressed ?? () {},
          )
        : null,
    content: Row(
      children: [
        Icon(
          Icons.info,
          color: isSuccess ? appColors.success.main : appColors.error.main,
        ),
        const SizedBox(width: Dimens.spacing_8),
        Flexible(
          child: Text(
            message,
            style: TextStyle(
              color: isSuccess ? appColors.success.main : appColors.error.main,
            ),
          ),
        ),
      ],
    ),
    showCloseIcon: actionText.isEmpty ? true : false,
    closeIconColor: isSuccess ? appColors.success.main : appColors.error.main,
  );
}
