import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';

import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/widget.dart';

class ErrorStateWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final String desc;
  final String buttonTxt;
  final VoidCallback onPressed;

  const ErrorStateWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.desc,
    required this.buttonTxt,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.all(Dimens.spacing_12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageWidget(
            color: appColors.bgGraySoft,
            imagePath: iconPath,
            width: Dimens.spacing_64,
            height: Dimens.spacing_64,
            isSvg: true,
          ),
          SizedBox(
            height: Dimens.spacing_32,
          ),
          TextWidget(
            text: title,
            style: Theme.of(context)
                .textTheme
                .pageTitle
                .copyWith(color: appColors.textInverse),
          ),
          SizedBox(
            height: Dimens.spacing_large,
          ),
          TextWidget(
            text: desc,
            style: Theme.of(context)
                .textTheme
                .bodyText
                .copyWith(color: appColors.textSubtle),
          ),
          SizedBox(
            height: Dimens.spacing_large,
          ),
          TextButtonWidget(
            label: buttonTxt,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
