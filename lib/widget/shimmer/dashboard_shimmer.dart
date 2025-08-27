import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/util/colors.dart';
import '../../shared/util/util.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final baseColor = appColors.gray.soft.withOpacity(0.3);
    final highlightColor = appColors.gray.subtle;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SizedBox(
        height: 600.h,
        child: Column(
          children: [
            // Header

            // Blue Card
            Container(
              height: Dimens.spacing_100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.gray.subtle,
                borderRadius: BorderRadius.circular(Dimens.spacing_small),
              ),
            ),
            SizedBox(height: Dimens.spacing_large),

            // Current Tasks Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: Dimens.spacing_100,
                    height: Dimens.spacing_large,
                    color: appColors.gray.subtle),
                Container(
                    width: Dimens.spacing_42,
                    height: Dimens.spacing_large,
                    color: appColors.gray.subtle),
              ],
            ),
            SizedBox(height: Dimens.spacing_large),

            // Task List
            ...List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimens.spacing_small),
                child: Container(
                  height: Dimens.spacing_64,
                  width: double.infinity,
                  color: appColors.gray.subtle,
                ),
              );
            }),

            SizedBox(height: Dimens.spacing_large),

            // Support Section
            Container(
                width: double.infinity,
                height: Dimens.spacing_large,
                color: appColors.gray.subtle),
            SizedBox(height: Dimens.spacing_large),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: Dimens.spacing_100,
                  decoration: BoxDecoration(
                    color: appColors.gray.subtle,
                    borderRadius: BorderRadius.circular(Dimens.spacing_large),
                  ),
                );
              }),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
