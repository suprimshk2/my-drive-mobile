import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/shimmer/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class ContactShimmer extends StatelessWidget {
  const ContactShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      height: double.infinity,
      color: Theme.of(context).indicatorColor,
      padding: const EdgeInsets.only(
        left: Dimens.spacing_8,
        right: Dimens.spacing_8,
        bottom: Dimens.spacing_12,
        top: Dimens.spacing_70,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: const CardShimmerWidget(),
          ),
          const SizedBox(height: Dimens.spacing_default),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.spacing_50),
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
                ),
                const SizedBox(height: Dimens.spacing_default),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.spacing_70),
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
                ),
                const SizedBox(height: Dimens.spacing_default),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.spacing_95),
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
                ),
                const SizedBox(height: Dimens.spacing_default),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacing_120),
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
            ),
          ),
        ],
      ),
    );
  }
}
