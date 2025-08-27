import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/episode/constant/enums.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/chip/chip_widget.dart';
import '../screen/widgets/milestone_chip_widget.dart';

Widget getEpisodeStatus(BuildContext context, String status) {
  final appColors = context.appColors;

  final statusValue = status.toUpperCase();

  if (statusValue == EpisodeStatus.CONFIRMED.name) {
    return ChipAltWidget(
      title: status,
      chipColor: appColors.info.subtle,
      textColor: appColors.info.bold,
      borderColor: appColors.borderInfo,
    );
  } else if (statusValue == EpisodeStatus.COMPLETED.name) {
    return ChipAltWidget(
      title: status,
      chipColor: appColors.bgSuccessSubtle,
      textColor: appColors.success.bold,
      borderColor: appColors.success.main,
    );
  } else if (statusValue == EpisodeStatus.CLOSED.name) {
    return ChipAltWidget(
      title: status,
      chipColor: appColors.bgGraySubtle,
      textColor: appColors.textSubtle,
      borderColor: appColors.gray.soft.withOpacity(0.5),
    );
  } else if (statusValue == EpisodeStatus.PRELIMINARY.name) {
    return ChipAltWidget(
      title: status,
      chipColor: appColors.primary.subtle,
      textColor: appColors.textPrimary,
      borderColor: appColors.borderPrimaryMain,
    );
  } else if (statusValue == EpisodeStatus.CANCELLED.name) {
    return ChipAltWidget(
      title: status,
      chipColor: appColors.bgWarningSubtle,
      textColor: appColors.error.bold,
      borderColor: appColors.error.main,
    );
  } else {
    return ChipAltWidget(
      title: status,
      chipColor: appColors.info.subtle,
      textColor: appColors.info.bold,
      borderColor: appColors.borderInfo,
    );
  }
}

Widget getMilestoneStatus(String status, BuildContext context) {
  final appColors = context.appColors;

  final statusValue = status.toUpperCase();
  if (status.isEmpty) return SizedBox();
  if (statusValue == MilestoneStatus.DUE.value) {
    return MilestoneChipWidget(
      title: status,
      chipColor: appColors.error.subtle,
      textColor: appColors.error.bold,
      borderColor: appColors.error.bold,
    );
  } else if (statusValue == MilestoneStatus.INPROGRESS.value) {
    return MilestoneChipWidget(
      title: status,
      chipColor: appColors.info.subtle,
      textColor: appColors.info.bold,
      borderColor: appColors.info.bold,
    );
  } else if (statusValue == MilestoneStatus.COMPLETED.value) {
    return MilestoneChipWidget(
      title: status,
      chipColor: appColors.bgSuccessSubtle,
      textColor: appColors.success.bold,
      borderColor: appColors.success.bold,
    );
  } else {
    return MilestoneChipWidget(
      title: status,
      chipColor: appColors.info.subtle,
      textColor: appColors.info.bold,
      borderColor: appColors.info.bold,
    );
  }
}
