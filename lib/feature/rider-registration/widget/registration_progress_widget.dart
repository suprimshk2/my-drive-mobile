import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class RegistrationProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const RegistrationProgressWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  text: 'Step $currentStep of $totalSteps',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: appColors.textSubtle,
                      ),
                ),
              ),
              TextWidget(
                text: '${((currentStep / totalSteps) * 100).round()}%',
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: appColors.primary.main,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacing_12),
          LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: appColors.bgGraySubtle,
            valueColor: AlwaysStoppedAnimation<Color>(appColors.primary.main),
            borderRadius: BorderRadius.circular(Dimens.radius_small),
          ),
          const SizedBox(height: Dimens.spacing_12),
          TextWidget(
            text: stepTitles[currentStep - 1],
            style: Theme.of(context).textTheme.bodyText.copyWith(
                  color: appColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
