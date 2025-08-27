import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypographyStyles {
  static final heading_1 = TextStyle(
    fontSize: Dimens.text_size_48.sp,
    height: 1.17,
    fontWeight: FontWeight.bold,
  );

  static final heading_2 = TextStyle(
    fontSize: Dimens.text_size_40.sp,
    height: 1.2,
    fontWeight: FontWeight.bold,
  );

  static final heading_3 = TextStyle(
    fontSize: Dimens.text_size_32.sp,
    height: 1.25,
    fontWeight: FontWeight.bold,
  );

  static final heading_4 = TextStyle(
    fontSize: Dimens.text_size_over_large.sp,
    height: 1.3,
    fontWeight: FontWeight.bold,
  );

  static final body_text_large_regular = TextStyle(
    fontSize: Dimens.text_size_extra_large.sp,
    height: 1.4,
    fontWeight: FontWeight.normal,
  );

  static final body_text_large_semibold = TextStyle(
    fontSize: Dimens.text_size_extra_large.sp,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  static final body_text_large_bold = TextStyle(
    fontSize: Dimens.text_size_extra_large.sp,
    height: 1.4,
    fontWeight: FontWeight.bold,
  );

  static final body_text_regular_regular = TextStyle(
    fontSize: Dimens.text_size_large.sp,
    height: 1.5,
    fontWeight: FontWeight.normal,
  );

  static final body_text_regular_semibold = TextStyle(
    fontSize: Dimens.text_size_large.sp,
    height: 1.5,
    fontWeight: FontWeight.w600,
  );

  static final body_text_regular_bold = TextStyle(
    fontSize: Dimens.text_size_large.sp,
    height: 1.5,
    fontWeight: FontWeight.bold,
  );

  static final body_text_small_regular = TextStyle(
    fontSize: Dimens.text_size_small.sp,
    height: 1.7,
    fontWeight: FontWeight.normal,
  );

  static final body_text_small_semibold = TextStyle(
    fontSize: Dimens.text_size_small.sp,
    height: 1.7,
    fontWeight: FontWeight.w600,
  );
  static final body_text_small_bold = TextStyle(
    fontSize: Dimens.text_size_small.sp,
    height: 1.7,
    fontWeight: FontWeight.bold,
  );
  static final body_text_medium_semibold = TextStyle(
    fontSize: Dimens.text_size_default.sp,
    height: 1.7,
    fontWeight: FontWeight.w600,
  );
}
