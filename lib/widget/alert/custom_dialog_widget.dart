import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_filled_button_widget.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_outlined_button_widget.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final Color iconColor;
  final String primaryButtonLabel;
  final VoidCallback onPrimaryButtonPressed;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryButtonPressed;
  final double widthFactor;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry buttonPadding;

  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.iconColor,
    required this.primaryButtonLabel,
    required this.onPrimaryButtonPressed,
    this.secondaryButtonLabel,
    this.onSecondaryButtonPressed,
    this.widthFactor = 0.95,
    this.contentPadding = const EdgeInsets.all(Dimens.spacing_32),
    this.buttonPadding = const EdgeInsets.all(Dimens.spacing_large),
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: contentPadding,
              child: Column(
                children: [
                  ImageWidget(
                    isSvg: true,
                    imagePath: iconPath,
                    height: Dimens.spacing_48,
                    width: Dimens.spacing_48,
                    color: iconColor,
                  ),
                  const SizedBox(height: Dimens.spacing_large),
                  TextWidget(
                    text: title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: appColors.textInverse),
                  ),
                  const SizedBox(height: Dimens.spacing_large),
                  TextWidget(
                    textAlign: TextAlign.center,
                    text: description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText
                        .copyWith(color: appColors.textSubtle),
                  ),
                ],
              ),
            ),
            Padding(
              padding: buttonPadding,
              child: Row(
                children: [
                  if (secondaryButtonLabel != null) ...[
                    Expanded(
                      child: RoundedOutlinedButtonWidget(
                        label: secondaryButtonLabel!,
                        onPressed: onSecondaryButtonPressed ?? () {},
                      ),
                    ),
                    SizedBox(width: Dimens.spacing_large),
                  ],
                  RoundedFilledButtonWidget(
                    context: context,
                    label: primaryButtonLabel,
                    onPressed: onPrimaryButtonPressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
