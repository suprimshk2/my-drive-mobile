import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';

import '../../../shared/shared.dart';
import '../../../widget/widget.dart';

class InformationTile extends StatelessWidget {
  final String title;
  final Widget leadingIcon;
  final Widget trailingIcon;
  final VoidCallback? onTap;
  final VoidCallback? onTrailingTap;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;
  final Color? backgroundColor;
  final double iconSize;
  final TextStyle? titleStyle;

  const InformationTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.trailingIcon,
    this.onTap,
    this.onTrailingTap,
    this.padding = const EdgeInsets.symmetric(
        horizontal: Dimens.spacing_8, vertical: Dimens.spacing_large),
    this.showDivider = true,
    this.backgroundColor,
    this.iconSize = Dimens.text_size_over_large,
    this.titleStyle,
  });

  /// Factory constructor for document type tile
  factory InformationTile.document({
    required String title,
    required VoidCallback onDownload,
    required Color loadingIndicatorColor,
    VoidCallback? onTap,
    bool isLoading = false,
    bool showDivider = true,
    required Color leadingIconColor,
    required Color trailingIconColor,
  }) {
    return InformationTile(
      title: title,
      leadingIcon: ImageWidget(
        isSvg: true,
        imagePath: ImageConstants.IC_INFO_DOCUMENT,
        width: Dimens.text_size_over_large,
        height: Dimens.text_size_over_large,
        color: leadingIconColor,
      ),
      trailingIcon: isLoading
          ? SizedBox(
              width: Dimens.text_size_extra_large,
              height: Dimens.text_size_extra_large,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(loadingIndicatorColor)),
            )
          : ImageWidget(
              isSvg: true,
              imagePath: ImageConstants.IC_DOWNLOAD,
              width: Dimens.text_size_over_large,
              height: Dimens.text_size_over_large,
              color: trailingIconColor,
            ),
      onTap: onTap,
      onTrailingTap: isLoading ? null : onDownload,
      showDivider: showDivider,
    );
  }

  /// Factory constructor for link type tile
  factory InformationTile.link({
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
    required Color leadingIconColor,
    required Color trailingIconColor,
  }) {
    return InformationTile(
      title: title,
      leadingIcon: Icon(
        CupertinoIcons.link,
        size: Dimens.text_size_extra_large,
        color: leadingIconColor,
      ),
      trailingIcon: Icon(
        Icons.chevron_right,
        color: trailingIconColor,
        size: Dimens.text_size_over_large,
      ),
      onTap: onTap,
      showDivider: showDivider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: padding,
            color: backgroundColor,
            child: Row(
              children: [
                // Leading icon (document or link icon)
                leadingIcon,

                const SizedBox(width: Dimens.spacing_8),

                // Title text
                Expanded(
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text: title,
                    style: Theme.of(context).textTheme.bodyTextBold.copyWith(
                          color: appColors.textInverse,
                        ),
                  ),
                ),
                const SizedBox(width: Dimens.spacing_8),

                // Trailing icon (download or chevron)
                GestureDetector(
                  onTap: onTrailingTap,
                  child: trailingIcon,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: appColors.borderGraySoftAlpha50,
          ),
      ],
    );
  }
}
