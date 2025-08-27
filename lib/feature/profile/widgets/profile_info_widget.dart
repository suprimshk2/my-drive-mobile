import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:mydrivenepal/widget/widget.dart';

class ProfileInfoWidget extends StatelessWidget {
  final IconData? icon;
  final String? iconImage;
  final String itemTitle;
  final String? itemDesc;
  final Widget? itemContent;

  const ProfileInfoWidget({
    super.key,
    this.icon,
    this.iconImage,
    required this.itemTitle,
    this.itemDesc,
    this.itemContent,
  });

  @override
  Widget build(BuildContext context) {
    bool hasIcon = icon != null;
    bool hasIconImage = iconImage != null;

    bool hasItemDesc = itemDesc != null;
    bool hasItemContent = itemContent != null;

    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
      child: Column(
        children: [
          const SizedBox(height: Dimens.spacing_large),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    (!hasIcon && !hasIconImage)
                        ? SizedBox()
                        : hasIcon
                            ? Icon(
                                icon,
                                size: Dimens.spacing_large,
                                color: appColors.textSubtle,
                              )
                            : SVGPictureWidget(
                                image: iconImage ?? '',
                                width: Dimens.spacing_extra_large,
                                height: Dimens.spacing_extra_large,
                                color: appColors.textSubtle,
                              ),
                    const SizedBox(width: Dimens.spacing_8),
                    Expanded(
                      child: TextWidget(
                        textAlign: TextAlign.left,
                        text: itemTitle,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: appColors.textSubtle),
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimens.spacing_6),
              Expanded(
                flex: 6,
                child: (!hasItemContent && !hasItemDesc)
                    ? SizedBox()
                    : hasItemDesc
                        ? TextWidget(
                            textAlign: TextAlign.left,
                            text: itemDesc!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText
                                .copyWith(color: appColors.textInverse),
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                          )
                        : itemContent!,
              ),
            ],
          ),
          const SizedBox(height: Dimens.spacing_small),
          Divider(
              height: 1,
              thickness: 0.4,
              color: appColors.borderGraySoftAlpha50),
        ],
      ),
    );
  }
}
