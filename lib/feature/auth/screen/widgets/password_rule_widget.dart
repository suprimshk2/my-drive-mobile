import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:mydrivenepal/widget/text/text.dart';

class PasswordRuleWidget extends StatelessWidget {
  final String rule;
  final bool isChecked;
  const PasswordRuleWidget({
    super.key,
    required this.rule,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isChecked
                ? CupertinoIcons.check_mark_circled_solid
                : CupertinoIcons.check_mark_circled,
            color: isChecked
                ? appColors.bgPrimaryMain
                : appColors.borderGraySoftAlpha50,
            size: Dimens.spacing_large,
          ),
          SizedBox(width: Dimens.spacing_large),
          Expanded(
            child: TextWidget(
              text: rule,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodyText
                  .copyWith(color: appColors.textInverse),
            ),
          ),
        ],
      ),
    );
  }
}
