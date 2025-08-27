import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:shimmer/shimmer.dart';

class TodoShimmerWidget extends StatelessWidget {
  final bool showShimmerForTodo;
  final bool showShimmerForQuestion;
  final bool showShimmerForAcknowledgement;

  const TodoShimmerWidget({
    super.key,
    this.showShimmerForTodo = true,
    this.showShimmerForQuestion = false,
    this.showShimmerForAcknowledgement = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      children: [
        _getShimmer(context),
        Spacer(),
        if (showShimmerForAcknowledgement)
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: Dimens.spacing_8,
              horizontal: Dimens.spacing_8,
            ),
            height: Dimens.spacing_42,
            child: Shimmer.fromColors(
              baseColor: appColors.gray.soft.withOpacity(0.3),
              highlightColor: Colors.grey[200]!,
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.gray.subtle.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.spacing_8),
                  ),
                ),
              ),
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: Dimens.spacing_4),
          height: Dimens.spacing_64,
          child: Shimmer.fromColors(
            baseColor: appColors.gray.soft.withOpacity(0.3),
            highlightColor: Colors.grey[200]!,
            child: Container(
              decoration: BoxDecoration(
                color: appColors.gray.subtle.withOpacity(0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.radius_large),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getShimmer(BuildContext context) {
    final appColors = context.appColors;

    if (showShimmerForQuestion) {
      return Column(
        children: [
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: Dimens.spacing_4),
                height: Dimens.spacing_30,
                // width: index == 1 ? 20 : double.infinity,
                child: Shimmer.fromColors(
                  baseColor: appColors.gray.soft.withOpacity(0.3),
                  highlightColor: Colors.grey[200]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColors.gray.subtle.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Dimens.spacing_4),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: Dimens.spacing_over_large),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: Dimens.spacing_default),
              height: Dimens.spacing_50,
              child: Shimmer.fromColors(
                baseColor: appColors.gray.soft.withOpacity(0.3),
                highlightColor: Colors.grey[200]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: appColors.gray.subtle.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Dimens.spacing_4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (showShimmerForTodo || showShimmerForAcknowledgement) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(vertical: Dimens.spacing_4),
          height: Dimens.spacing_30,
          child: Shimmer.fromColors(
            baseColor: appColors.gray.soft.withOpacity(0.3),
            highlightColor: Colors.grey[200]!,
            child: Container(
              decoration: BoxDecoration(
                color: appColors.gray.subtle.withOpacity(0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.spacing_4),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
