import 'package:flutter/material.dart';

import 'package:mydrivenepal/shared/util/util.dart';
import 'package:mydrivenepal/widget/widget.dart';

class DynamicShimmer extends StatelessWidget {
  final int shimmerLength;

  const DynamicShimmer({
    super.key,
    required this.shimmerLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        shimmerLength,
        (index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.spacing_12),
          child: CardShimmerWidget(),
        ),
      ),
    );
  }
}
