import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/topic/constants/enums.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/widget/chip/chip_widget.dart';

Widget getTopicStatus(BuildContext context, String status) {
  final appColors = context.appColors;

  final statusValue = status.toUpperCase();

  if (statusValue == TopicStatus.DUE.value) {
    return ChipAltWidget(
      title: TopicStatus.DUE.displayName,
      chipColor: appColors.error.subtle,
      textColor: appColors.error.bold,
      borderColor: AppColors.transparent,
      radius: 32,
    );
  } else if (statusValue == TopicStatus.COMPLETED.value) {
    return ChipAltWidget(
      title: TopicStatus.COMPLETED.displayName,
      chipColor: appColors.bgSuccessSubtle,
      textColor: appColors.success.bold,
      borderColor: AppColors.transparent,
      radius: 32,
    );
  } else if (statusValue == TopicStatus.INPROGRESS.value) {
    return ChipAltWidget(
      title: TopicStatus.INPROGRESS.displayName,
      chipColor: appColors.info.subtle,
      textColor: appColors.info.bold,
      borderColor: AppColors.transparent,
      radius: 32,
    );
  } else {
    return ChipAltWidget(
      title: status,
      chipColor: appColors.info.subtle,
      textColor: appColors.info.main,
      borderColor: AppColors.transparent,
      radius: 32,
    );
  }
}
