import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onSuffixPressed;
  final bool isSearching;

  final double? height;

  const SearchTextField(
      {Key? key,
      required this.hintText,
      this.controller,
      this.onChanged,
      this.onSubmitted,
      this.isSearching = false,
      this.onSuffixPressed,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return TextField(
      onSubmitted: onSubmitted,
      controller: controller,
      keyboardType: TextInputType.text,
      onChanged: onChanged,
      style: Theme.of(context)
          .textTheme
          .caption
          .copyWith(color: appColors.textInverse),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: appColors.textMuted),
        prefixIconConstraints: BoxConstraints(),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
          child: ImageWidget(
            imagePath: ImageConstants.IC_SEARCH,
            width: 16,
            height: 16,
            isSvg: true,
            color: appColors.gray.main,
            fit: BoxFit.contain,
          ),
        ),
        suffixIcon: isSearching
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  size: 16,
                  color: appColors.gray.main,
                ),
                onPressed: onSuffixPressed,
              )
            : null,
        filled: true,
        fillColor: appColors.bgGraySubtle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: appColors.borderGraySoftAlpha50,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: appColors.borderGraySoftAlpha50,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: appColors.borderGraySoftAlpha50,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
