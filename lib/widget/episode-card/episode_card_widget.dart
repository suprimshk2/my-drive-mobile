import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/episode/episode.dart';
import 'package:mydrivenepal/feature/episode/utils/episode_utils.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

import 'package:mydrivenepal/shared/theme/app_text_theme.dart';

import '../../shared/shared.dart';
import '../widget.dart';

class EpisodeCard extends StatelessWidget {
  final String title;
  final String description;
  final String procedureDate;
  final VoidCallback? onViewTask;
  final Color? color;
  final Color? iconColor;
  final String status;
  const EpisodeCard({
    super.key,
    required this.title,
    required this.description,
    required this.procedureDate,
    this.onViewTask,
    required this.status,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final isActive = (status.toUpperCase() == 'CONFIRMED');

    return GestureDetector(
      onTap: onViewTask,
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? appColors.bgPrimaryMain
              : color ?? appColors.primary.subtle,
          borderRadius: BorderRadius.circular(Dimens.spacing_large),
        ),
        padding: EdgeInsets.all(Dimens.spacing_large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: title,
              style: Theme.of(context).textTheme.bodyText.copyWith(
                  color:
                      isActive ? appColors.gray.subtle : appColors.gray.strong),
            ),
            SizedBox(height: Dimens.spacing_4),
            TextWidget(
              text: description,
              style: Theme.of(context).textTheme.caption.copyWith(
                  color:
                      isActive ? appColors.gray.subtle : appColors.gray.strong),
              maxLines: 4,
              softWrap: true,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: Dimens.spacing_small),

            getEpisodeStatus(context, status),

            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.spacing_large),
              child: Divider(
                color: isActive
                    ? appColors.borderInfoSubtle
                    : appColors.borderInfo,
                height: 1,
                thickness: 0.7,
              ),
            ),

            // Footer
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageWidget(
                  color: isActive
                      ? appColors.gray.subtle
                      : iconColor ?? appColors.gray.main,
                  imagePath: ImageConstants.IC_CALENDAR_CHECK,
                  width: Dimens.spacing_large,
                  height: Dimens.spacing_large,
                  isSvg: true,
                ),
                SizedBox(width: Dimens.spacing_8),
                TextWidget(
                  text: EpisodeConstant.procedureDate,
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: isActive
                          ? appColors.gray.subtle
                          : appColors.gray.strong),
                ),
                SizedBox(width: Dimens.spacing_8),
                TextWidget(
                  text: procedureDate,
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: isActive
                          ? appColors.gray.subtle
                          : appColors.gray.strong),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
