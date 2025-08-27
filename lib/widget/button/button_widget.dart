import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      this.icon,
      required this.label,
      this.onPressed,
      this.height,
      this.textColor,
      this.width,
      this.isLoading = false,
      this.fontSize = 16,
      this.enabled = true,
      this.needBorder = false,
      this.child,
      this.loadingMsg,
      this.backgroundColor,
      this.borderColor,
      this.padding = const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      this.loaderSize = 24,
      this.borderRadius,
      this.textDecoration = TextDecoration.none,
      this.loadingColor,
      this.minSize,
      this.overlayColor,
      this.tapTargetSize,
      this.borderWidth})
      : super(key: key);

  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isLoading;
  final double? fontSize;
  final bool enabled;
  final bool needBorder;
  final Widget? child;
  final String? loadingMsg;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final double loaderSize;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final TextDecoration? textDecoration;
  final Color? loadingColor;
  final Widget? icon;
  final Size? minSize;
  final MaterialTapTargetSize? tapTargetSize;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final textStyle = Theme.of(context).textTheme.bodyText.copyWith(
          fontSize: fontSize,
          color: textColor ?? AppColors.white,
        );

    return Container(
      width: width,
      height: height,
      decoration: buildButtonDecoration(
        context,
        enabled: enabled,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: TextButton(
          style: TextButton.styleFrom(
            minimumSize: minSize,
            tapTargetSize: tapTargetSize,
            overlayColor: overlayColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              side: needBorder
                  ? BorderSide(
                      width: borderWidth ?? 1,
                      color: borderColor ?? appColors.gray.strong,
                    )
                  : BorderSide.none,
              borderRadius: borderRadius ??
                  BorderRadius.circular(
                    Dimens.radius_large,
                  ),
            ),
          ),
          onPressed: isLoading || !enabled ? null : onPressed,
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: loaderSize,
                      width: loaderSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          loadingColor ?? AppColors.white,
                        ),
                      ),
                    ),
                    if (loadingMsg != null) ...[
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        loadingMsg!,
                        style: textStyle,
                      )
                    ]
                  ],
                )
              : child ??
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) Expanded(child: SizedBox.shrink()),
                      Text(
                        label,
                        style: textStyle,
                      ),
                      if (icon != null)
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child:
                                icon, // Your icon widget (e.g., Icon(Icons.arrow_forward))
                          ),
                        ),
                    ],
                  )),
    );
  }
}

BoxDecoration buildButtonDecoration(
  BuildContext context, {
  required bool enabled,
  Color? backgroundColor,
  BorderRadius? borderRadius,
}) {
  final appColors = context.appColors;

  final button_gradient = LinearGradient(
    colors: appColors.gradients.button,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  Gradient? gradient;
  if (!enabled) {
    gradient = button_gradient.withOpacity(0.5);
  } else {
    final isHolista = dotenv.env['FLAVOR'] == FLAVOR.Holista;
    gradient = isHolista ? null : button_gradient;
  }

  return BoxDecoration(
    gradient: gradient,
    color: backgroundColor,
    borderRadius: borderRadius ?? BorderRadius.circular(Dimens.radius_large),
  );
}
