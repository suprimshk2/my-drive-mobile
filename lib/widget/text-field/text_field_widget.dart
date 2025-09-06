import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mydrivenepal/feature/theme/theme_provider.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    Key? key,
    required this.name,
    this.isRequired = false,
    this.focusNode,
    this.inputFormat,
    this.controller,
    this.nextNode,
    this.textInputType,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction = TextInputAction.done,
    this.hintText,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.label,
    this.onChanged,
    this.validator = const [],
    this.autoFocus = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.onFieldSubmitted,
    this.onSaved,
    this.onPrefixPressed,
    this.onSuffixPressed,
    this.textAlign = TextAlign.start,
    this.borderColor,
    this.initialValue,
    this.errorText = 'This field is required',
    this.textFieldHeight,
  }) : super(key: key);

  final String name;
  final List<FormFieldValidator<String>> validator;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormat;
  final FocusNode? nextNode;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? label;
  final Function(String?)? onChanged;
  // final double? borderRadius;
  final bool autoFocus;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final void Function()? onPrefixPressed;
  final void Function()? onSuffixPressed;
  final TextAlign? textAlign;
  final Color? borderColor;
  final String? initialValue;
  final bool isRequired;
  final String? errorText;
  final double? textFieldHeight;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  List<FormFieldValidator<String>>? validators = [];

  @override
  void initState() {
    if (widget.isRequired) {
      validators!
          .add(FormBuilderValidators.required(errorText: widget.errorText));
    }
    if (widget.validator.isNotEmpty) {
      validators!.addAll(widget.validator);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    Color textColor =
        widget.readOnly ? appColors.textMuted : appColors.textSubtle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          TextWidget(
            text: widget.label!,
            style:
                Theme.of(context).textTheme.caption.copyWith(color: textColor),
          ),
          const SizedBox(height: Dimens.spacing_4)
        ],
        SizedBox(height: 2),
        FormBuilderTextField(
          name: widget.name,
          initialValue: widget.initialValue,
          inputFormatters: widget.inputFormat,
          style: Theme.of(context)
              .textTheme
              .bodyText
              .copyWith(color: appColors.textInverse),
          onSaved: widget.onSaved,
          textAlign: widget.textAlign ?? TextAlign.start,
          textCapitalization: widget.textCapitalization,
          autofocus: widget.autoFocus,
          obscureText: widget.obscureText,
          autovalidateMode: widget.autovalidateMode,
          validator: FormBuilderValidators.compose(validators!.isNotEmpty
              ? [
                  ...validators!,
                ]
              : []),
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onSubmitted: widget.onFieldSubmitted,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(widget.nextNode);
          },
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          decoration: InputDecoration(
            filled: true,
            fillColor: appColors.bgGraySubtle,
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText
                .copyWith(color: appColors.textMuted),
            counterText: '',
            isDense: true,
            contentPadding: EdgeInsets.all(
              Dimens.spacing_large,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : IconButton(
                    icon: Icon(
                      widget.prefixIcon,
                      size: 16,
                      color: appColors.bgPrimaryMain,
                    ),
                    onPressed: widget.onPrefixPressed,
                  ),
            suffixIcon: widget.suffixIcon == null
                ? null
                : IconButton(
                    icon: Icon(
                      widget.suffixIcon,
                      size: 16,
                      color: appColors.bgPrimaryMain,
                    ),
                    onPressed: widget.onSuffixPressed,
                  ),
            hintText: widget.hintText,
            border: generateInputFieldBorder(appColors.borderGraySoftAlpha50),
            enabledBorder: widget.readOnly
                ? generateInputFieldBorder(appColors.borderGraySoftAlpha50)
                : generateInputFieldBorder(appColors.borderGraySoftAlpha50),
            focusedBorder: widget.readOnly
                ? generateInputFieldBorder(appColors.borderGraySoftAlpha50)
                : generateInputFieldBorder(appColors.borderPrimaryMain),
            errorBorder: generateInputFieldBorder(appColors.error.main),
            focusedErrorBorder: generateInputFieldBorder(appColors.error.main),
            errorStyle: Theme.of(context).textTheme.caption.copyWith(
                  color: appColors.error.bold,
                ),
          ),
        ),
      ],
    );
  }
}
