import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:shimmer/shimmer.dart';

class AnnouncementShimmerWidget extends StatelessWidget {
  const AnnouncementShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Dimens.spacing_300 / 2,
              width: Dimens.spacing_250,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_large,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_32,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.secondary.bold,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.spacing_large),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimens.spacing_large),
            SizedBox(
              height: 50,
              width: 300,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_large,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_32,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.secondary.bold,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.spacing_large),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimens.spacing_large),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: Dimens.spacing_extra_large,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacing_large,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacing_32,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.secondary.bold,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.spacing_large),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: Dimens.spacing_extra_large,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacing_large,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacing_32,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.secondary.bold,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.spacing_large),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: Dimens.spacing_large),
            SizedBox(
              height: Dimens.spacing_300,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_large,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacing_32,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.secondary.bold,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.spacing_large),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
