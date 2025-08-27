import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/episode/episode.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';

import '../../../../shared/shared.dart';
import '../../../../widget/widget.dart';
import '../../utils/episode_utils.dart';

class MilestoneCard extends StatelessWidget {
  final String title;
  final String? description;
  final String date;
  final VoidCallback? onViewTask;
  final int maxDescriptionLines;
  final String status;
  const MilestoneCard({
    super.key,
    required this.title,
    this.description,
    required this.date,
    this.onViewTask,
    this.maxDescriptionLines = 3,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return GestureDetector(
      onTap: onViewTask,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.primary.subtle,
          borderRadius: BorderRadius.circular(Dimens.spacing_8),
        ),
        padding: EdgeInsets.all(Dimens.spacing_large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidget(
                    maxLines: 2,
                    text: title,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText.copyWith(
                          color: appColors.gray.strong,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                getMilestoneStatus(status, context),
              ],
            ),
            if (isNotEmpty(description)) ...[
              SizedBox(height: Dimens.spacing_4),
              TextWidget(
                text: description!,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: appColors.gray.strong),
                maxLines: 4,
                softWrap: true,
                textAlign: TextAlign.start,
              ),
            ],

            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.spacing_large),
              child: Divider(
                color: appColors.borderGraySoftAlpha50,
                height: 1,
                thickness: 0.6,
              ),
            ),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageWidget(
                      imagePath: ImageConstants.IC_CALENDAR_CHECK,
                      width: Dimens.spacing_large,
                      height: Dimens.spacing_large,
                      isSvg: true,
                    ),
                    SizedBox(width: Dimens.spacing_8),
                    Text(
                      date,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: appColors.gray.strong),
                    ),
                  ],
                ),
                // View Task button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_8,
                    vertical: Dimens.spacing_4,
                  ),
                  child: TextWidget(
                    text: EpisodeConstant.viewTasks,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: appColors.gray.strong),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
