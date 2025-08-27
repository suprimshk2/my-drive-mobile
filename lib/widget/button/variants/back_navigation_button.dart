import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:mydrivenepal/widget/image/image.dart';
import 'package:mydrivenepal/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackNavigationWidget extends StatelessWidget {
  final String buttonLabel;
  final VoidCallback? onPressed;
  const BackNavigationWidget({
    super.key,
    required this.buttonLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      highlightColor: AppColors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onPressed ??
          () {
            if (context.canPop()) {
              context.pop();
            }
          },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageWidget(
            imagePath: ImageConstants.IC_ARROW_LEFT,
            height: 20.w,
            width: 20.w,
            color: appColors.textPrimary,
            isSvg: true,
          ),
          SizedBox(width: 10.h),
          TextWidget(
            text: buttonLabel,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: appColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
