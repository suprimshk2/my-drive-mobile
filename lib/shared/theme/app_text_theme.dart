import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// final TextTheme lightBaseTextTheme = TextTheme(
//   displayLarge: TextStyle(
//     // Hero Title
//     fontFamily: 'VarelaRound',
//     fontSize: 64.sp,
//     height: 1.2,
//     color: AppColors.gray_main,
//     fontWeight: FontWeight.w500, // Medium
//   ),
//   displayMedium: TextStyle(
//     // Large Title
//     fontFamily: 'VarelaRound',
//     fontSize: 32.sp,
//     height: 1.2,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   displaySmall: TextStyle(
//     // Page Title
//     fontFamily: 'VarelaRound',
//     fontSize: 24.sp,
//     height: 1.2,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   headlineMedium: TextStyle(
//     // Subtitle
//     fontFamily: 'VarelaRound',
//     fontSize: 20.sp,
//     height: 1.2,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   bodyLarge: TextStyle(
//     // Body Text
//     fontSize: 16.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w400, // Regular
//     color: AppColors.gray_main,
//   ),
//   bodyMedium: TextStyle(
//     // Body Text Bold
//     fontSize: 16.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   bodySmall: TextStyle(
//     // Caption
//     fontSize: 14.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w400,
//     color: AppColors.gray_main,
//   ),
//   labelMedium: TextStyle(
//     // Caption Bold
//     fontSize: 14.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   labelSmall: TextStyle(
//     // Body Text Small
//     fontSize: 12.sp,
//     height: 1.0,
//     fontWeight: FontWeight.w400,
//     color: AppColors.gray_main,
//   ),
// );

// final TextTheme darkBaseTextTheme = TextTheme(
//   displayLarge: TextStyle(
//     // Hero Title
//     fontFamily: 'VarelaRound',
//     fontSize: 64.sp,
//     height: 1.2,
//     fontWeight: FontWeight.w500, // Medium
//     color: AppColors.gray_main,
//   ),
//   displayMedium: TextStyle(
//     // Large Title
//     fontFamily: 'VarelaRound',
//     fontSize: 32.sp,
//     height: 1.2,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   displaySmall: TextStyle(
//     // Page Title
//     fontFamily: 'VarelaRound',
//     fontSize: 24.sp,
//     height: 1.2,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   headlineMedium: TextStyle(
//     // Subtitle
//     fontFamily: 'VarelaRound',
//     fontSize: 20.sp,
//     height: 1.2,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   bodyLarge: TextStyle(
//     // Body Text
//     fontSize: 16.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w400, // Regular
//     color: AppColors.gray_main,
//   ),
//   bodyMedium: TextStyle(
//     // Body Text Bold
//     fontSize: 16.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   bodySmall: TextStyle(
//     // Caption
//     fontSize: 14.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w400,
//     color: AppColors.gray_main,
//   ),
//   labelMedium: TextStyle(
//     // Caption Bold
//     fontSize: 14.sp,
//     height: 1.5,
//     fontWeight: FontWeight.w500,
//     color: AppColors.gray_main,
//   ),
//   labelSmall: TextStyle(
//     // Body Text Small
//     fontSize: 12.sp,
//     height: 1.0,
//     fontWeight: FontWeight.w400,
//     color: AppColors.gray_main,
//   ),
// );

extension CustomTextStyles on TextTheme {
  TextStyle get heroTitle => displayLarge!;
  TextStyle get largeTitle => displayMedium!;
  TextStyle get pageTitle => displaySmall!;
  TextStyle get subtitle => headlineMedium!;
  TextStyle get bodyText => bodyLarge!;
  TextStyle get bodyTextBold => bodyMedium!;
  TextStyle get caption => bodySmall!;
  TextStyle get captionBold => labelMedium!;
  TextStyle get bodyTextSmall => labelSmall!;

  TextStyle get buttonText => bodyMedium!;
}
