import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';

import '../../shared/shared.dart';
import '../../shared/util/dimens.dart';
import '../widget.dart';

class ChipAltWidget extends StatelessWidget {
  final String title;
  final Color chipColor;
  final Color textColor;
  final Color borderColor;
  final double radius;

  const ChipAltWidget({
    super.key,
    required this.title,
    required this.chipColor,
    required this.textColor,
    required this.borderColor,
    this.radius = 4,
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
        horizontal: Dimens.spacing_8,
        vertical: Dimens.spacing_4,
      ),
      child: TextWidget(
        text: title,
        style: Theme.of(context).textTheme.caption.copyWith(
              color: textColor,
            ),
      ),
    );
  }
}
