import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';

import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

class CommsTile extends StatelessWidget {
  final VoidCallback onTap;
  final String userImagePath;
  final String userName;
  final String message;
  final String date;

  final bool isMessageReceived;

  const CommsTile({
    super.key,
    required this.onTap,
    required this.userImagePath,
    required this.userName,
    required this.message,
    required this.date,
    required this.isMessageReceived,
  });

  @override
  Widget build(BuildContext context) {
    bool hasProfileImage = isNotEmpty(userImagePath);

    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing_small,
          vertical: Dimens.spacing_large,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: appColors.borderGraySoftAlpha50,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Dimens.spacing_44,
              height: Dimens.spacing_44,
              decoration: BoxDecoration(
                color: appColors.gray.main,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.spacing_44),
                child: hasProfileImage
                    ? ImageWidget(
                        imagePath: userImagePath,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: TextWidget(
                          text: getInitialsForProfileImage(userName),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText
                              .copyWith(color: AppColors.white),
                        ),
                      ),
              ),
            ),
            SizedBox(width: Dimens.spacing_large),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: userName,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style:
                              Theme.of(context).textTheme.bodyTextBold.copyWith(
                                    color: appColors.textInverse,
                                    fontWeight: isMessageReceived
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                        ),
                      ),
                      TextWidget(
                          text: date,
                          style: Theme.of(context)
                              .textTheme
                              .bodyTextSmall
                              .copyWith(
                                color: appColors.textMuted,
                              )),
                    ],
                  ),
                  SizedBox(height: Dimens.spacing_4),
                  TextWidget(
                    text: message,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: appColors.textSubtle,
                          fontWeight: isMessageReceived
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
