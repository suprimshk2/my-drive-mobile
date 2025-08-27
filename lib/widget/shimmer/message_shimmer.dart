import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/util/colors.dart';
import '../../shared/util/dimens.dart';

class ChatShimmerScreen extends StatelessWidget {
  const ChatShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      showBackButton: false,
      showAppbar: false,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(Dimens.spacing_large),
              itemCount: 8,
              itemBuilder: (_, index) {
                // Alternate between sent and received messages
                final isSent = index % 3 == 0;
                return isSent
                    ? _buildSentMessageShimmer(context)
                    : _buildReceivedMessageShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedMessageShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(Dimens.spacing_12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(Dimens.spacing_large),
                    bottomLeft: Radius.circular(Dimens.spacing_large),
                    bottomRight: Radius.circular(Dimens.spacing_large),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(width: 180, height: 14),
                    const SizedBox(height: 8),
                    _buildShimmerBox(width: 140, height: 14),
                    const SizedBox(height: 8),
                    _buildShimmerBox(width: 100, height: 14),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildShimmerBox(width: 60, height: 10),
              ),
            ],
          ),
        ),
        const SizedBox(width: 60),
      ],
    );
  }

  Widget _buildSentMessageShimmer(BuildContext appContext) {
    final appColors = appContext.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 60),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(Dimens.spacing_12),
                decoration: BoxDecoration(
                  color: appColors.gray.soft.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Dimens.spacing_large),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(Dimens.spacing_large),
                    bottomRight: Radius.circular(Dimens.spacing_large),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildShimmerBox(
                      width: 160,
                      height: 14,
                      baseColor: appColors.gray.subtle,
                      highlightColor: appColors.gray.soft.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    _buildShimmerBox(
                      width: Dimens.spacing_120,
                      height: 14,
                      baseColor: appColors.gray.subtle,
                      highlightColor: appColors.gray.soft.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildShimmerBox(width: 60, height: 10),
                    const SizedBox(width: 4),
                    _buildShimmerCircle(10),
                    const SizedBox(width: 2),
                    _buildShimmerCircle(10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildShimmerCircle(
    double size, {
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
