import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class CustomDashboardAppBar extends StatelessWidget {
  final VoidCallback onIdCardTap;
  final String? userImageUrl;
  final String userName;

  const CustomDashboardAppBar({
    super.key,
    required this.onIdCardTap,
    this.userImageUrl,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final logoPath = dotenv.env["LOGO_PATH"]!;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimens.spacing_large,
        horizontal: Dimens.spacing_8,
      ),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: appColors.borderGraySoftAlpha50,
        )),
      ),
      child: Row(
        children: [
          Image.asset(
            logoPath,
            fit: BoxFit.contain,
            width: 0.3.sw,
          ),
          Spacer(),
          GestureDetector(
            onTap: onIdCardTap,
            child: ImageWidget(
              imagePath: ImageConstants.IC_PERSON_CARD,
              width: Dimens.spacing_over_large,
              height: Dimens.spacing_over_large,
              isSvg: true,
              color: appColors.bgGrayBold,
            ),
          ),
          SizedBox(
            width: Dimens.spacing_default,
          ),
          GestureDetector(
            onTap: () => context.pushNamed(AppRoute.profile.name),
            child: ImageAvatar(
              userImageUrl: userImageUrl,
              userName: userName,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageAvatar extends StatelessWidget {
  const ImageAvatar({
    super.key,
    this.userImageUrl,
    required this.userName,
    this.height,
    this.width,
  });

  final double? width;
  final double? height;
  final String? userImageUrl;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final hasProfileImage = isNotEmpty(userImageUrl);

    return Container(
      width: width ?? Dimens.spacing_32,
      height: height ?? Dimens.spacing_32,
      decoration: BoxDecoration(
        color: appColors.gray.soft,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width ?? Dimens.spacing_32),
        child: hasProfileImage
            ? ImageWidget(
                imagePath: userImageUrl!,
                fit: BoxFit.cover,
              )
            : Center(
                child: TextWidget(
                  text: getInitialsForProfileImage(userName).toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText
                      .copyWith(color: AppColors.white),
                ),
              ),
      ),
    );
  }
}
