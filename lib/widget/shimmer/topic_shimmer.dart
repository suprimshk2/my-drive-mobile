import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/util/colors.dart';
import '../../shared/util/dimens.dart';
import '../scaffold/scaffold_widget.dart';

class TopicShimmerScreen extends StatelessWidget {
  const TopicShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final baseColor = appColors.gray.soft.withOpacity(0.3);
    final highlightColor = appColors.gray.subtle;

    return ScaffoldWidget(
      padding: 0,
      top: 0,
      bottom: 0,
      showAppbar: false,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacing_large),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerLine(
                  width: Dimens.spacing_120, height: Dimens.spacing_over_large),
              const SizedBox(height: Dimens.spacing_large),
              _shimmerLine(
                  width: double.infinity, height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_large),
              _shimmerLine(
                  width: double.infinity, height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_extra_large),
              _shimmerLine(
                  width: Dimens.spacing_100, height: Dimens.spacing_over_large),
              const SizedBox(height: Dimens.spacing_small),
              const SizedBox(height: Dimens.spacing_extra_large),
              _shimmerTitleRow(),
              const SizedBox(height: Dimens.spacing_large),
              _shimmerTaskTile(),
              _shimmerTaskTile(),
              const SizedBox(height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_large),
              _shimmerTitleRow(),
              const SizedBox(height: Dimens.spacing_large),
              _shimmerTaskTile(),
              _shimmerTaskTile(),
              _shimmerTaskTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.white,
    );
  }

  Widget _shimmerTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _shimmerLine(width: 120, height: 20),
        Container(
          width: 80,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _shimmerTaskTile() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 12),
          Expanded(child: _shimmerLine(width: double.infinity, height: 16)),
        ],
      ),
    );
  }
}
