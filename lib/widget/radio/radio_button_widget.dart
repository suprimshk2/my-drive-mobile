import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';

class RadioButtonWidget extends StatefulWidget {
  final String title;
  final int? selectedValue;
  final String option1;
  final String option2;
  final Function(int?)? onChanged;

  const RadioButtonWidget({
    super.key,
    required this.title,
    this.selectedValue,
    required this.option1,
    required this.option2,
    this.onChanged,
  });

  @override
  RadioButtonWidgetState createState() => RadioButtonWidgetState();
}

class RadioButtonWidgetState extends State<RadioButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_12),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio(
              value: 0,
              activeColor: Theme.of(context).primaryColor,
              groupValue: widget.selectedValue,
              onChanged: widget.onChanged,
            ),
            TextWidget(text: widget.option1),
            const SizedBox(width: Dimens.spacing_42),
            Radio(
              value: 1,
              activeColor: Theme.of(context).primaryColor,
              groupValue: widget.selectedValue,
              onChanged: widget.onChanged,
            ),
            TextWidget(text: widget.option2),
          ],
        )
      ],
    );
  }
}
