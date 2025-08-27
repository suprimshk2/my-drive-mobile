import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

import '../../feature/profile/constants/profile_strings.dart';

enum InfoType { error, success, warning, info, disclaimer }

class InfoContainer extends StatelessWidget {
  final String title;
  final String? message;
  final InfoType type;

  const InfoContainer({
    super.key,
    required this.title,
    this.message,
    this.type = InfoType.info,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = _getImagePathForType(type);
    final textColor = _getTextColorForType(context, type);
    final backgroundColor = _getBackgroundColorForType(context, type);

    final appColors = context.appColors;

    return Container(
      padding: EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageWidget(
            imagePath: imagePath,
            height: Dimens.spacing_over_large,
            width: Dimens.spacing_over_large,
            isSvg: true,
            color: textColor,
          ),
          SizedBox(width: Dimens.spacing_extra_small),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  text: title,
                  textAlign: TextAlign.start,
                  style: type == InfoType.disclaimer
                      ? Theme.of(context).textTheme.caption.copyWith(
                            color: textColor,
                          )
                      : Theme.of(context).textTheme.bodyTextBold.copyWith(
                            color: textColor,
                          ),
                ),
                if (isNotEmpty(message)) ...[
                  SizedBox(height: Dimens.spacing_4),
                  TextWidget(
                    text: message!,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: textColor,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (type == InfoType.disclaimer) ...[
            SizedBox(width: Dimens.spacing_large),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.spacing_8,
                vertical: Dimens.spacing_4,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextWidget(
                text: ProfileStrings.disclaimerLearnMore,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: appColors.gray.strong,
                    ),
              ),
            )
          ],
        ],
      ),
    );
  }

  String _getImagePathForType(InfoType type) {
    return switch (type) {
      InfoType.error => ImageConstants.IC_WARNING_ROUND,
      InfoType.success => ImageConstants.IC_CHECK_CIRCLE_FILL,
      InfoType.warning => ImageConstants.IC_WARNING_ROUND,
      InfoType.info => ImageConstants.IC_INFO_CIRCLE_FILL,
      InfoType.disclaimer => ImageConstants.IC_WARNING,
    };
  }

  Color _getTextColorForType(BuildContext context, InfoType type) {
    final appColors = context.appColors;

    return switch (type) {
      InfoType.error => appColors.textInverse,
      InfoType.success => appColors.textInverse,
      InfoType.warning => appColors.textInverse,
      InfoType.info => appColors.textInverse,
      InfoType.disclaimer => AppColors.white,
    };
  }

  Color _getBackgroundColorForType(BuildContext context, InfoType type) {
    final appColors = context.appColors;

    return switch (type) {
      InfoType.error => appColors.error.main,
      InfoType.success => appColors.success.main,
      InfoType.warning => appColors.warning.main,
      InfoType.info => appColors.info.main,
      InfoType.disclaimer => appColors.info.soft,
    };
  }
}
