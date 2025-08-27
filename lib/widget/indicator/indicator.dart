import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({super.key, this.isActive = false});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      width: 10.0,
      height: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: isActive ? appColors.secondary.main : appColors.gray.soft,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
