import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String iconPath;
  final String desc;
  final Color iconColor;

  const EmptyStateWidget({
    super.key,
    required this.iconPath,
    required this.desc,
    required this.iconColor,
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
            color: iconColor,
            imagePath: iconPath,
            width: Dimens.spacing_64,
            height: Dimens.spacing_64,
            isSvg: true,
          ),
          SizedBox(
            height: Dimens.spacing_large,
          ),
          TextWidget(
            text: desc,
            style: Theme.of(context)
                .textTheme
                .bodyTextBold
                .copyWith(color: appColors.textInverse),
          ),
        ],
      ),
    );
  }
}
