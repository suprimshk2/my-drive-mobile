import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/util/dimens.dart';
import '../../../../widget/text/text_widget.dart';

class MilestoneChipWidget extends StatelessWidget {
  final String title;
  final Color chipColor;
  final Color textColor;
  final Color borderColor;
  final double radius;
  final double titleSize;

  const MilestoneChipWidget({
    super.key,
    required this.title,
    required this.chipColor,
    required this.textColor,
    required this.borderColor,
    this.radius = 24,
    this.titleSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(radius),
        color: chipColor,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_6,
        vertical: Dimens.spacing_6,
      ),
      child: TextWidget(
        text: title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontSize: titleSize,
            ),
      ),
    );
  }
}
