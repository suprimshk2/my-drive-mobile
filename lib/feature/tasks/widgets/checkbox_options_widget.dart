import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/checkbox/custom_checkbox.dart';
import 'package:mydrivenepal/widget/widget.dart';

class CheckboxOptionWidget extends StatefulWidget {
  final bool isSelected;
  final String option;
  final Function(String) onOptionSelected;

  const CheckboxOptionWidget({
    super.key,
    required this.isSelected,
    required this.option,
    required this.onOptionSelected,
  });

  @override
  State<CheckboxOptionWidget> createState() => _CheckboxOptionWidgetState();
}

class _CheckboxOptionWidgetState extends State<CheckboxOptionWidget> {
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
                text: widget.option,
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
    return CustomCheckbox(
      value: widget.isSelected,
      onChanged: (value) => widget.onOptionSelected(widget.option),
    );
  }
}
