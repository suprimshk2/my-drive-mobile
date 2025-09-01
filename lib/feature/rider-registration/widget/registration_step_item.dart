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
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: appColors.borderGraySoftAlpha50,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacing_large,
          vertical: Dimens.spacing_12,
        ),
        title: Row(
          children: [
            if (isCompleted) ...[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: appColors.success.main,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: Dimens.spacing_12),
            ],
            Expanded(
              child: TextWidget(
                text: title,
                style: Theme.of(context).textTheme.bodyText.copyWith(
                      color: appColors.textInverse,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: appColors.textMuted,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
