import 'package:flutter/material.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/feature/dashboard/disclaimer_viewmodel.dart';
import '../../../shared/shared.dart';
import '../../../widget/checkbox/custom_checkbox.dart';
import '../constant/dashboard_string.dart';

class DisclaimerContent extends StatelessWidget {
  const DisclaimerContent({
    super.key,
    this.isDisclaimer,
    required this.isFromDashboard,
    this.ackDate,
  });
  final bool? isDisclaimer;
  final bool isFromDashboard;
  final DateTime? ackDate;
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    DisclaimerViewModel disclaimerViewModel = locator<DisclaimerViewModel>();

    return ChangeNotifierProvider(
      create: (_) => disclaimerViewModel,
      child: Consumer<DisclaimerViewModel>(
        builder: (
          context,
          disclaimerValue,
          _,
        ) {
          final isForDashboard =
              (isFromDashboard == true && disclaimerValue.isChecked);
          final isForProfile =
              (!(isFromDashboard == false) || disclaimerValue.isChecked);

          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed Header
                Container(
                  color: appColors.bgGraySoft,
                  padding: const EdgeInsets.all(Dimens.spacing_large),
                  child: Row(
                    children: [
                      TextWidget(
                        text: DashboardString.disclaimerTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: appColors.textInverse),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: appColors.textInverse,
                          size: Dimens.text_size_24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.spacing_large),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ackDate != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: appColors.success.main,
                                  size: Dimens.text_size_20,
                                ),
                                const SizedBox(width: Dimens.spacing_4),
                                Expanded(
                                  child: TextWidget(
                                    textAlign: TextAlign.start,
                                    text:
                                        '${DashboardString.disclaimerAckDate} ${formatDate(ackDate.toString())}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: appColors.textInverse,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: Dimens.spacing_12),
                          TextWidget(
                            textAlign: TextAlign.justify,
                            text: DashboardString.disclaimerText,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: appColors.textInverse,
                                ),
                          ),
                          const SizedBox(height: Dimens.spacing_12),
                          TextWidget(
                            textAlign: TextAlign.justify,
                            text: DashboardString.disclaimerText2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: appColors.textInverse,
                                ),
                          ),
                          const SizedBox(height: Dimens.spacing_12),
                          TextWidget(
                            textAlign: TextAlign.justify,
                            text: DashboardString.disclaimerText3,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: appColors.textInverse,
                                ),
                          ),
                          const SizedBox(height: Dimens.spacing_extra_large),
                          Row(
                            children: [
                              CustomCheckbox(
                                value: isFromDashboard
                                    ? disclaimerValue.isChecked
                                    : isDisclaimer == false
                                        ? disclaimerValue.isChecked
                                        : isDisclaimer ?? false,
                                onChanged: (value) {
                                  if (isFromDashboard == false &&
                                      isDisclaimer == true) {
                                    {}
                                  } else {
                                    disclaimerValue.toggleCheckbox();
                                  }
                                },
                              ),
                              const SizedBox(width: Dimens.spacing_4),
                              TextWidget(
                                text: DashboardString.disclaimerAck,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: appColors.textInverse,
                                    ),
                              )
                            ],
                          ),
                          const SizedBox(height: Dimens.spacing_extra_large),
                          RoundedFilledButtonWidget(
                            context: context,
                            enabled:
                                isFromDashboard ? isForDashboard : isForProfile,
                            label: DashboardString.disclaimerAgree,
                            isLoading:
                                disclaimerValue.disclaimerResponse.isLoading,
                            onPressed: disclaimerValue.isChecked
                                ? () {
                                    disclaimerValue.submitDisclaimer(() {
                                      Navigator.pop(context);
                                    });
                                  }
                                : null,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
