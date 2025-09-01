import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/button/button.dart';

class PhotoUploadWidget extends StatelessWidget {
  final String title;
  final String? photoPath;
  final VoidCallback onUpload;
  final Widget? placeholder;
  final bool isRequired;

  const PhotoUploadWidget({
    Key? key,
    required this.title,
    this.photoPath,
    required this.onUpload,
    this.placeholder,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title,
            style: Theme.of(context).textTheme.bodyText.copyWith(
                  color: appColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: Dimens.spacing_large),
          if (photoPath != null && photoPath!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.radius_default),
                border: Border.all(
                  color: appColors.borderGraySoft,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.radius_default),
                child: ImageWidget(
                  imagePath: photoPath!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: Dimens.spacing_large),
          ] else if (placeholder != null) ...[
            placeholder!,
            const SizedBox(height: Dimens.spacing_large),
          ],
          RoundedFilledButtonWidget(
            context: context,
            label: "Add a photo${isRequired ? '*' : ''}",
            onPressed: onUpload,
            backgroundColor: AppColors.transparent,
            textColor: appColors.primary.main,
            // borderColor: appColors.primary.main,
            // needBorder: true,
          ),
        ],
      ),
    );
  }
}
