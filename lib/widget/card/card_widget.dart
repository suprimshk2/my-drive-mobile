import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/util.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final Color? bgColor;
  final double? width;

  CardWidget({
    super.key,
    required this.child,
    this.bgColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_large,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_32,
      ),
      width: width,
      decoration: BoxDecoration(
        color: bgColor ?? appColors.secondary.bold,
        borderRadius: const BorderRadius.all(
          Radius.circular(Dimens.spacing_large),
        ),
      ),
      child: child,
    );
  }
}
