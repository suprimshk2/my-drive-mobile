import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class RegistrationStepItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isCompleted;
  final bool isActive;

  const RegistrationStepItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.isCompleted = false,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appColors.borderGraySoft,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: Dimens.spacing_2,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  text: title,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: appColors.textInverse,
                      ),
                ),
              ),
            ),
            if (isCompleted) ...[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  color: appColors.success.main,
                  Icons.check_circle_outline,
                  size: Dimens.spacing_large,
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: appColors.bgGrayMain,
          size: Dimens.spacing_12,
        ),
        onTap: onTap,
      ),
    );
  }
}
