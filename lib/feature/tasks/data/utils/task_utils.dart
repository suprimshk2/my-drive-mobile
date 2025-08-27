import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

import '../../../episode/screen/widgets/milestone_chip_widget.dart';
import '../../constants/enums.dart';

Widget getTaskStatus(String status, BuildContext context) {
  final appColors = context.appColors;

  final statusValue = status.toUpperCase();
  if (status.isEmpty) return SizedBox();
  if (statusValue == TaskStatus.DUE.value) {
    return MilestoneChipWidget(
      title: status,
      chipColor: appColors.error.subtle,
      textColor: appColors.error.bold,
      borderColor: appColors.error.main,
    );
  } else if (statusValue == TaskStatus.INPROGRESS.value) {
    return MilestoneChipWidget(
      title: status,
      chipColor: appColors.warning.subtle,
      textColor: appColors.warning.bold,
      borderColor: appColors.warning.main,
    );
  } else if (statusValue == TaskStatus.COMPLETED.value) {
    return MilestoneChipWidget(
      titleSize: 10,
      title: status,
      chipColor: appColors.success.subtle,
      textColor: appColors.success.bold,
      borderColor: appColors.success.main,
    );
  } else {
    return MilestoneChipWidget(
      title: status,
      chipColor: appColors.info.subtle,
      textColor: appColors.info.bold,
      borderColor: appColors.info.main,
    );
  }
}
