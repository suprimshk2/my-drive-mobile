import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/di/config/config_model.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

import 'package:mydrivenepal/shared/util/colors.dart';

class ThemeService {
  final ThemeConfig themeConfig;

  ThemeService({required this.themeConfig});

  ThemeData get lightTheme => _buildLightTheme(themeConfig.light);
  ThemeData get darkTheme => _buildDarkTheme(themeConfig.dark);

  ThemeData _buildLightTheme(ThemeModeConfig theme) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: theme.primary.main,
      primaryColorLight: theme.primary.soft,
      canvasColor: AppColors.white,
      cardColor: theme.gray.subtle,
      indicatorColor: AppColors.white,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(AppColors.transparent),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      fontFamily: 'Varela',
      iconTheme: const IconThemeData(color: AppColors.black),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.white,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.white,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        // color: theme.gray.main,
        surfaceTintColor: theme.gray.main,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        shadowColor: theme.gray.subtle,
        elevation: 0,
        surfaceTintColor: AppColors.white,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          // Hero Title
          fontFamily: 'VarelaRound',
          fontSize: 64.sp,
          height: 1.2,
          color: theme.gray.main,
          fontWeight: FontWeight.w500, // Medium
        ),
        displayMedium: TextStyle(
          // Large Title
          fontFamily: 'VarelaRound',
          fontSize: 32.sp,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: theme.gray.main,
        ),
        displaySmall: TextStyle(
          // Page Title
          fontFamily: 'VarelaRound',
          fontSize: 24.sp,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: theme.gray.main,
        ),
        headlineMedium: TextStyle(
          // Subtitle
          fontFamily: 'VarelaRound',
          fontSize: 20.sp,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: theme.gray.main,
        ),
        bodyLarge: TextStyle(
          // Body Text
          fontSize: 16.sp,
          height: 1.5,
          fontWeight: FontWeight.w400, // Regular
          color: theme.gray.main,
        ),
        bodyMedium: TextStyle(
          // Body Text Bold
          fontSize: 16.sp,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: theme.gray.main,
        ),
        bodySmall: TextStyle(
          // Caption
          fontSize: 14.sp,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: theme.gray.main,
        ),
        labelMedium: TextStyle(
          // Caption Bold
          fontSize: 14.sp,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: theme.gray.main,
        ),
        labelSmall: TextStyle(
          // Body Text Small
          fontSize: 12.sp,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: theme.gray.main,
        ),
      ),
      extensions: [
        AppColorExtension(
          primary: theme.primary,
          secondary: theme.secondary,
          success: theme.success,
          error: theme.error,
          warning: theme.warning,
          info: theme.info,
          gray: theme.gray,
          gradients: theme.gradients,
          bgPrimaryMain: theme.primary.main,
          bgSecondaryMain: theme.secondary.main,
          bgSuccessSubtle: theme.success.subtle,
          bgWarningSubtle: theme.warning.subtle,
          bgGraySoft: theme.gray.subtle,
          bgGrayMain: theme.gray.main,
          bgGrayBold: theme.gray.bold,
          bgGrayStrong: theme.gray.strong,
          bgGraySubtle: theme.gray.subtle,
          textPrimary: theme.primary.main,
          textSecondary: theme.secondary.main,
          textSuccessAccent: theme.success.bold,
          textWarningAccent: theme.warning.bold,
          textInverse: theme.gray.strong,
          textMuted: theme.gray.main,
          textSubtle: theme.gray.bold,
          textOnSurface: theme.gray.subtle,
          borderPrimarySubtle: theme.primary.subtle,
          borderPrimaryMain: theme.primary.main,
          borderSecondarySubtle: theme.secondary.subtle,
          borderSuccessSubtle: theme.success.subtle,
          borderWarningSubtle: theme.warning.subtle,
          borderDangerSubtle: theme.error.subtle,
          borderInfoSubtle: theme.info.subtle,
          borderInfo: theme.info.main,
          borderGraySubtle: theme.gray.subtle,
          borderGraySoftAlpha50: theme.gray.soft.withOpacity(0.5),
          borderGraySoft: theme.gray.subtle,
          borderGrayBold: theme.gray.bold,
          borderGrayStrong: theme.gray.strong,
        ),
      ],
    );
  }

  ThemeData _buildDarkTheme(ThemeModeConfig theme) {
    return ThemeData(
      scaffoldBackgroundColor: theme.gray.strong,
      primaryColor: theme.primary.main,
      primaryColorLight: theme.primary.soft,
      canvasColor: AppColors.black,
      cardColor: theme.gray.subtle,
      indicatorColor: AppColors.black,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: theme.gray.strong,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(AppColors.transparent),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      fontFamily: 'Varela',
      iconTheme: const IconThemeData(color: AppColors.white),
      bottomAppBarTheme: BottomAppBarTheme(
        color: theme.gray.strong,
        surfaceTintColor: AppColors.white,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: theme.gray.strong,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: theme.gray.strong,
        shadowColor: theme.gray.subtle,
        elevation: 0,
        surfaceTintColor: AppColors.white,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          // Hero Title
          fontFamily: 'VarelaRound',
          fontSize: 64.sp,
          height: 1.2,
          fontWeight: FontWeight.w500, // Medium
          color: theme.gray.subtle,
        ),
        displayMedium: TextStyle(
          // Large Title
          fontFamily: 'VarelaRound',
          fontSize: 32.sp,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: theme.gray.subtle,
        ),
        displaySmall: TextStyle(
          // Page Title
          fontFamily: 'VarelaRound',
          fontSize: 24.sp,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: theme.gray.subtle,
        ),
        headlineMedium: TextStyle(
          // Subtitle
          fontFamily: 'VarelaRound',
          fontSize: 20.sp,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: theme.gray.subtle,
        ),
        bodyLarge: TextStyle(
          // Body Text
          fontSize: 16.sp,
          height: 1.5,
          fontWeight: FontWeight.w400, // Regular
          color: theme.gray.subtle,
        ),
        bodyMedium: TextStyle(
          // Body Text Bold
          fontSize: 16.sp,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: theme.gray.subtle,
        ),
        bodySmall: TextStyle(
          // Caption
          fontSize: 14.sp,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: theme.gray.subtle,
        ),
        labelMedium: TextStyle(
          // Caption Bold
          fontSize: 14.sp,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: theme.gray.subtle,
        ),
        labelSmall: TextStyle(
          // Body Text Small
          fontSize: 12.sp,
          height: 1.0,
          fontWeight: FontWeight.w400,
          color: theme.gray.subtle,
        ),
      ),
      extensions: [
        AppColorExtension(
          primary: theme.primary,
          secondary: theme.secondary,
          success: theme.success,
          error: theme.error,
          warning: theme.warning,
          info: theme.info,
          gray: theme.gray,
          gradients: theme.gradients,
          bgPrimaryMain: theme.primary.soft,
          bgSecondaryMain: theme.secondary.soft,
          bgSuccessSubtle: theme.success.soft,
          bgWarningSubtle: theme.warning.soft,
          bgGraySoft: theme.gray.bold,
          bgGrayMain: theme.gray.soft.withOpacity(0.5),
          bgGrayBold: theme.gray.subtle,
          bgGrayStrong: theme.gray.subtle,
          bgGraySubtle: theme.gray.bold,
          textPrimary: theme.primary.subtle,
          textSecondary: theme.secondary.soft,
          textSuccessAccent: theme.success.soft,
          textWarningAccent: theme.warning.main,
          textInverse: theme.gray.subtle,
          textMuted: theme.gray.soft,
          textSubtle: theme.gray.subtle,
          textOnSurface: theme.gray.strong,
          borderPrimarySubtle: theme.primary.main,
          borderPrimaryMain: theme.primary.soft,
          borderSecondarySubtle: theme.secondary.bold,
          borderSuccessSubtle: theme.success.main,
          borderWarningSubtle: theme.warning.main,
          borderDangerSubtle: theme.error.main,
          borderInfoSubtle: theme.info.main,
          borderInfo: theme.info.soft,
          borderGraySubtle: theme.gray.strong,
          borderGraySoftAlpha50: theme.gray.main,
          borderGraySoft: theme.gray.bold,
          borderGrayBold: theme.gray.soft.withOpacity(0.5),
          borderGrayStrong: theme.gray.subtle,
        ),
      ],
    );
  }
}
