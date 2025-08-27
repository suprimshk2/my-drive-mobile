import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/util/colors.dart';
import '../../shared/util/dimens.dart';

class CardShimmerWidget extends StatelessWidget {
  final double? height;
  final int? count;
  final bool needMargin;
  final double? width;
  const CardShimmerWidget({
    super.key,
    this.height,
    this.needMargin = true,
    this.count = 5,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true, // Add this line to fix the vertical viewport issue
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
      itemCount: count,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.symmetric(vertical: Dimens.spacing_12),
        height: height ?? Dimens.spacing_64,
        width: width ?? double.infinity,
        child: Shimmer.fromColors(
          baseColor:
              appColors.gray.soft.withOpacity(0.3), // Customize the base color
          highlightColor: Colors.grey[200]!, // Customize the highlight color
          child: Container(
            margin: needMargin
                ? const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_large,
                  )
                : null,
            decoration: BoxDecoration(
              color: appColors.gray.soft.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimens.spacing_large),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
