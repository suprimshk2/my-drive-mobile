import 'package:flutter/material.dart';
import 'package:mydrivenepal/di/config/config_model.dart';

class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final ColorPalette primary;
  final ColorPalette secondary;
  final ColorPalette success;
  final ColorPalette warning;
  final ColorPalette error;
  final ColorPalette info;
  final ColorPalette gray;
  final GradientColors gradients;

  // Background colors
  final Color bgPrimaryMain;
  final Color bgSecondaryMain;
  final Color bgSuccessSubtle;
  final Color bgWarningSubtle;
  final Color bgGraySubtle;
  final Color bgGraySoft;
  final Color bgGrayMain;
  final Color bgGrayBold;
  final Color bgGrayStrong;

  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textSuccessAccent;
  final Color textWarningAccent;
  final Color textInverse;
  final Color textMuted;
  final Color textSubtle;
  final Color textOnSurface;

  // Border colors
  final Color borderPrimarySubtle;
  final Color borderPrimaryMain;
  final Color borderSecondarySubtle;
  final Color borderSuccessSubtle;
  final Color borderWarningSubtle;
  final Color borderDangerSubtle;
  final Color borderInfoSubtle;
  final Color borderInfo;
  final Color borderGraySubtle;
  final Color borderGraySoftAlpha50;
  final Color borderGraySoft;
  final Color borderGrayBold;
  final Color borderGrayStrong;

  AppColorExtension({
    required this.primary,
    required this.secondary,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.gray,
    required this.gradients,

    // Background colors
    required this.bgPrimaryMain,
    required this.bgSecondaryMain,
    required this.bgSuccessSubtle,
    required this.bgWarningSubtle,
    required this.bgGraySubtle,
    required this.bgGraySoft,
    required this.bgGrayMain,
    required this.bgGrayBold,
    required this.bgGrayStrong,

    // Text colors
    required this.textPrimary,
    required this.textSecondary,
    required this.textSuccessAccent,
    required this.textWarningAccent,
    required this.textInverse,
    required this.textMuted,
    required this.textSubtle,
    required this.textOnSurface,

    // Border colors
    required this.borderPrimarySubtle,
    required this.borderPrimaryMain,
    required this.borderSecondarySubtle,
    required this.borderSuccessSubtle,
    required this.borderWarningSubtle,
    required this.borderDangerSubtle,
    required this.borderInfoSubtle,
    required this.borderInfo,
    required this.borderGraySubtle,
    required this.borderGraySoftAlpha50,
    required this.borderGraySoft,
    required this.borderGrayBold,
    required this.borderGrayStrong,
  });

  @override
  ThemeExtension<AppColorExtension> copyWith() => this;

  @override
  ThemeExtension<AppColorExtension> lerp(
      ThemeExtension<AppColorExtension>? other, double t) {
    return this;
  }
}

extension AppColorExtensionHelper on BuildContext {
  AppColorExtension get appColors =>
      Theme.of(this).extension<AppColorExtension>()!;
}
