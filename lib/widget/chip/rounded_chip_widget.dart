import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';

import '../../shared/shared.dart';
import '../widget.dart';

class RoundedChipWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color? chipColor;
  final Color? textColor;
  final Color? borderColor;

  const RoundedChipWidget({
    super.key,
    this.chipColor,
    required this.title,
    this.fontSize = 14,
    this.textColor = AppColors.white,
    this.borderColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBorder = borderColor != null;
    return Container(
      decoration: BoxDecoration(
        border: hasBorder ? Border.all(color: borderColor!) : null,
        borderRadius: BorderRadius.circular(Dimens.spacing_32),
        color: chipColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_8,
      ),
      child: TextWidget(
        text: title,
        style: Theme.of(context).textTheme.caption.copyWith(
              color: textColor,
              fontSize: fontSize,
            ),
      ),
    );
  }
}
