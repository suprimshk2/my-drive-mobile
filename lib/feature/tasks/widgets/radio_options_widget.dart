import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/widget.dart';

class RadioOptionWidget extends StatefulWidget {
  final bool isSelected;
  final String option;
  final String? label;
  final Function(String) onOptionSelected;

  const RadioOptionWidget({
    super.key,
    required this.isSelected,
    required this.option,
    required this.onOptionSelected,
    this.label,
  });

  @override
  State<RadioOptionWidget> createState() => _RadioOptionWidgetState();
}

class _RadioOptionWidgetState extends State<RadioOptionWidget> {
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    Color tileBgColor =
        widget.isSelected ? appColors.primary.subtle : appColors.bgGraySubtle;

    Color? borderColor = widget.isSelected
        ? appColors.bgPrimaryMain
        : appColors.borderGraySoftAlpha50;

    Color textColor =
        widget.isSelected ? appColors.gray.strong : appColors.textInverse;

    return GestureDetector(
      onTap: () => widget.onOptionSelected(widget.option),
      child: Container(
        padding: EdgeInsets.all(Dimens.spacing_large),
        margin: EdgeInsets.only(bottom: Dimens.spacing_8),
        decoration: BoxDecoration(
          color: tileBgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(Dimens.spacing_8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextWidget(
                text: widget.label ?? widget.option,
                textAlign: TextAlign.left,
                maxLines: 4,
                style: Theme.of(context)
                    .textTheme
                    .bodyText
                    .copyWith(color: textColor),
              ),
            ),
            _getRadioButton(),
          ],
        ),
      ),
    );
  }

  _getRadioButton() {
    final appColors = context.appColors;

    return widget.isSelected
        ? Icon(
            Icons.check_circle_rounded,
            color: appColors.bgPrimaryMain,
            size: Dimens.spacing_extra_large,
          )
        : Icon(
            Icons.circle_outlined,
            color: appColors.borderGraySoftAlpha50,
            size: Dimens.spacing_extra_large,
          );
  }
}
