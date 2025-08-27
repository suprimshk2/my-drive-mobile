import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/dashboard/widgets/custom_appbar.dart';
import 'package:mydrivenepal/feature/episode/episode.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/button/variants/outlined_button_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({
    super.key,
    this.userImageUrl,
    required this.userName,
    this.height,
    required this.category,
    this.width,
    required this.userId,
  });

  final double? width;
  final double? height;
  final String? userImageUrl;
  final String userName;
  final String category;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(right: Dimens.spacing_large),
      padding: EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        border: Border.all(color: appColors.borderGraySoftAlpha50, width: 0.7),
        borderRadius: BorderRadius.circular(Dimens.radius_small),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageAvatar(
            width: Dimens.spacing_72,
            height: Dimens.spacing_72,
            userName: userName,
            userImageUrl: userImageUrl,
          ),
          SizedBox(height: Dimens.spacing_6),
          TextWidget(
            text: userName,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyText
                .copyWith(color: appColors.textInverse),
          ),
          SizedBox(height: Dimens.spacing_6),
          TextWidget(
            text: category,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyTextSmall
                .copyWith(color: appColors.textSubtle),
          ),
          SizedBox(height: Dimens.spacing_default),
          SizedBox(
            width: 90.w,
            child: OutlinedButtonWidget(
              borderColor: appColors.borderPrimaryMain,
              textColor: appColors.textPrimary,
              context: context,
              onPressed: () {
                context.pushNamed(AppRoute.chat.name, extra: {
                  "userId": userId,
                  "fullName": userName,
                });
              },
              label: EpisodeConstant.chat,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
