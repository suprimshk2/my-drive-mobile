import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

class MyBulletWidget extends StatelessWidget {
  const MyBulletWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: appColors.gray.strong,
        shape: BoxShape.circle,
      ),
    );
  }
}
