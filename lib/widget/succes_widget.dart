import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:flutter/material.dart';
import '../shared/constant/image_constants.dart';
import '../shared/util/colors.dart';
import '../shared/util/dimens.dart';
import 'button/button.dart';
import 'text/text_widget.dart';

class SuccessWidget extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  const SuccessWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.buttonLabel,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageWidget(
              isSvg: true,
              imagePath: ImageConstants.IC_CHECK_CIRCLE_FILL,
              height: Dimens.spacing_64,
              width: Dimens.spacing_64,
              color: appColors.success.main,
            ),
            const SizedBox(height: Dimens.spacing_32),
            TextWidget(
              text: title,
              style: Theme.of(context).textTheme.pageTitle.copyWith(
                    color: appColors.textInverse,
                  ),
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
            SizedBox(height: Dimens.spacing_extra_large),
          ],
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: RoundedFilledButtonWidget(
              context: context, label: buttonLabel, onPressed: onPressed),
        ),
        const SizedBox(
          height: Dimens.spacing_large,
        ),
      ],
    );
  }
}
