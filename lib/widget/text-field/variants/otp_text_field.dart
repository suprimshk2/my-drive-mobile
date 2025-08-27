import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pinput/pinput.dart';

import '../../../shared/shared.dart';

class CustomFormBuilderOtpField extends FormBuilderField<String?> {
  CustomFormBuilderOtpField({
    super.key,
    required super.name,
    super.initialValue,
    String? label,
    required int otpLength,
    required bool enabled,
    bool isRequired = true,
    Function(String)? onCompleted,
  }) : super(
          validator: isRequired
              ? FormBuilderValidators.minLength(
                  otpLength,
                  errorText: 'This field is required',
                )
              : null,
          builder: (FormFieldState<String?> field) {
            return _OtpFieldWidget(
              otpLength: otpLength,
              onCompleted: onCompleted,
              enabled: enabled,
              label: label,
              isRequired: isRequired,
              field: field as _OtpFieldState,
            );
          },
        );

  @override
  FormBuilderFieldState<CustomFormBuilderOtpField, String?> createState() =>
      _OtpFieldState();
}

class _OtpFieldState
    extends FormBuilderFieldState<CustomFormBuilderOtpField, String?> {}

class _OtpFieldWidget extends StatefulWidget {
  final _OtpFieldState field;
  final int otpLength;
  final bool enabled;
  final String? label;
  final bool isRequired;
  final Function(String)? onCompleted;

  const _OtpFieldWidget({
    this.label,
    required this.otpLength,
    required this.onCompleted,
    required this.enabled,
    required this.isRequired,
    required this.field,
  });

  @override
  State<_OtpFieldWidget> createState() => _OtpFieldWidgetState();
}

class _OtpFieldWidgetState extends State<_OtpFieldWidget> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    bool hasError = widget.field.errorText != null;

    Color fillColor = appColors.bgGraySubtle;

    // var focusedBorderColor = appColors.primary.main;

    final defaultPinTheme = PinTheme(
      width: Dimens.spacing_56,
      height: Dimens.spacing_56,
      textStyle: Theme.of(context)
          .textTheme
          .bodyText
          .copyWith(color: appColors.textInverse),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(Dimens.radius_small),
        border: Border.all(
          color: widget.field.hasError
              ? appColors.error.main
              : appColors.borderGraySoftAlpha50,
        ),
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Pinput(
          length: widget.otpLength,
          controller: pinController,
          focusNode: focusNode,
          enabled: widget.enabled,
          autofocus: true,
          defaultPinTheme: defaultPinTheme,
          onChanged: (value) {
            if (hasError) {
              widget.field.reset();
            }
            widget.field.didChange(value);
          },
          onClipboardFound: (value) {
            pinController.setText(value);
          },
          onCompleted: (value) {
            if (value.length == widget.otpLength) {
              widget.onCompleted?.call(value);
            }
          },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: appColors.borderPrimaryMain,
              ),
            ],
          ),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(
                color: appColors.borderPrimaryMain,
              ),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyBorderWith(
            border: Border.all(color: appColors.error.main),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: Dimens.spacing_8),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacing_extra_large),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.field.errorText ?? '',
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: appColors.error.bold),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
