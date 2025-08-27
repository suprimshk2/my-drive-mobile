import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/util/colors.dart';
import '../../shared/util/dimens.dart';
import '../scaffold/scaffold_widget.dart';

class EpisodeDetailShimmer extends StatelessWidget {
  const EpisodeDetailShimmer({super.key});

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
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.spacing_large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerLine(
                  width: double.infinity, height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_small),
              _shimmerLine(width: 180, height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_small),
              _shimmerBadge(),
              const SizedBox(height: Dimens.spacing_large),
              _shimmerSearchBar(),
              const SizedBox(height: Dimens.spacing_large),
              _shimmerChipsRow(),
              const SizedBox(height: Dimens.spacing_large),
              Expanded(
                child: ListView.separated(
                  itemCount: 2,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: Dimens.spacing_large),
                  itemBuilder: (context, index) => _shimmerMilestoneCard(),
                ),
              ),
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

  Widget _shimmerBadge() {
    return Container(
      width: 80,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _shimmerTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) {
        return Container(
          width: 80,
          height: 24,
          color: AppColors.white,
        );
      }),
    );
  }

  Widget _shimmerSearchBar() {
    return Container(
      width: double.infinity,
      height: 40,
      color: AppColors.white,
    );
  }

  Widget _shimmerChipsRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(4, (index) {
        return Container(
          width: 70,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }),
    );
  }

  Widget _shimmerMilestoneCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(Dimens.spacing_large),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerLine(width: 140, height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_small),
              _shimmerLine(
                  width: double.infinity, height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_small),
              _shimmerLine(
                  width: double.infinity, height: Dimens.spacing_large),
              const SizedBox(height: Dimens.spacing_extra_small),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerLine(width: 100, height: Dimens.spacing_large),
                  Container(
                    width: 80,
                    height: Dimens.spacing_large,
                    color: AppColors.white,
                  ),
                ],
              ),
              const SizedBox(height: Dimens.spacing_large),
            ],
          ),
        ),
      ],
    );
  }
}
