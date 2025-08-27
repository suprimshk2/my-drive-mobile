import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerWidget extends StatelessWidget {
  const ListShimmerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      children: [
        SizedBox(
          height: Dimens.spacing_100,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacing_8,
              ),
              decoration: BoxDecoration(
                color: appColors.secondary.bold,
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.spacing_8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimens.spacing_default),
        SizedBox(
          height: Dimens.spacing_12,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacing_8,
              ),
              decoration: BoxDecoration(
                color: appColors.secondary.bold,
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.spacing_8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimens.spacing_default),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_50),
          child: SizedBox(
            height: Dimens.spacing_12,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacing_8,
                ),
                decoration: BoxDecoration(
                  color: appColors.secondary.bold,
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.spacing_8),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
