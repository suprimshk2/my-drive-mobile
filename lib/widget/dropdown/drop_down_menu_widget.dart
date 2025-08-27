import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

class DropDownMenuWidget<T> extends StatelessWidget {
  const DropDownMenuWidget({
    Key? key,
    required this.name,
    required this.label,
    required this.hint,
    required this.items,
    this.value,
    this.enabled = true,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    // this.prefixIcon = Icons.location_city,
    this.needPrefix = true,
    required this.onChanged,
  }) : super(key: key);

  final String name;
  final String label;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final bool enabled;
  final String? Function(T?)? validator;
  final AutovalidateMode autovalidateMode;
  // final IconData prefixIcon;
  final bool needPrefix;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Dimens.spacing_12),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: appColors.textInverse,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.01,
        ),
        SizedBox(
          height: 75,
          child: FormBuilderDropdown<T>(
            name: name,
            alignment: Alignment.bottomCenter,
            elevation: 2,
            items: items,
            autovalidateMode: autovalidateMode,
            validator: validator,
            initialValue: value,
            onChanged: (value) {
              onChanged(value);
            },
            dropdownColor: AppColors.white,
            decoration: InputDecoration(
              // prefixIcon: needPrefix
              //     ? Icon(
              //         prefixIcon,
              //         color: AppColors.green,
              //       )
              //     : null,

              fillColor: AppColors.white,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius_large),
                borderSide: BorderSide(
                  color: appColors.borderGraySoftAlpha50,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius_large),
                borderSide: BorderSide(
                  color: appColors.bgPrimaryMain,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius_large),
                borderSide: BorderSide(
                  color: appColors.error.main,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius_large),
                borderSide: BorderSide(
                  color: appColors.error.main,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
