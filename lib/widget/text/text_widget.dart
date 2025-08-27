import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final bool isBold;
  final double size;
  final TextStyle? style;
  final bool? adaptive;
  final double adaptiveValue;
  final double miniAdaptiveValue;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final bool? softWrap;
  final int? maxLines;

  const TextWidget({
    super.key,
    required this.text,
    this.isBold = false,
    this.size = Dimens.text_size_default,
    this.style,
    this.adaptive = false,
    this.adaptiveValue = 1,
    this.textAlign = TextAlign.center,
    this.textOverflow = TextOverflow.visible,
    this.miniAdaptiveValue = 0.5,
    this.softWrap = true,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Text(
      maxLines: maxLines,
      text,
      style: style ??
          Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: appColors.textInverse),
      textAlign: textAlign,
      overflow: textOverflow,
      softWrap: softWrap,
    );
  }
}
