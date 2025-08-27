import 'package:mydrivenepal/di/di.dart';
import 'package:mydrivenepal/feature/auth/constants/constants.dart';

import 'package:mydrivenepal/feature/auth/screen/forgot_password/forgot_password_viewmodel.dart';

import 'package:mydrivenepal/shared/constant/message/message.dart';
import 'package:mydrivenepal/shared/constant/route_names.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/util.dart';
import 'package:mydrivenepal/widget/text-field/variants/otp_text_field.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  // todo: remove the props later and get data from arguments
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpFormKey = GlobalKey<FormBuilderState>();

  final ForgotPasswordViewmodel forgotPwViewmodel =
      locator<ForgotPasswordViewmodel>();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ChangeNotifierProvider(
      create: (context) => forgotPwViewmodel,
      child: ScaffoldWidget(
        appbarTitle: AuthStrings.verifyOtpTitle,
        padding: Dimens.spacing_8,
        child: Consumer<ForgotPasswordViewmodel>(
            builder: (context, viewmodel, child) {
          bool isResendOtpUsecaseLoading =
              viewmodel.requestOtpUseCase.isLoading;

          bool isVerifyOtpUsecaseLoading = viewmodel.verifyOtpUseCase.isLoading;

          return Column(
            children: [
              SizedBox(height: 10.h),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
                child: TextWidget(
                  text: _getVerificationCodeDescription(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText
                      .copyWith(color: appColors.textInverse),
                ),
              ),
              SizedBox(height: 30.h),
              FormBuilder(
                key: _otpFormKey,
                child: CustomFormBuilderOtpField(
                  otpLength: 6,
                  enabled: true,
                  name: AuthTextfieldConstant.forgotPasswordOtp,
                ),
              ),
              SizedBox(height: 30.h),
              _buildResendOtpWidget(context, viewmodel),
              SizedBox(height: 30.h),
              RoundedFilledButtonWidget(
                context: context,
                label: AuthStrings.verifyOtpBtnText,
                onPressed: () => _onRequestOTP(viewmodel),
                isLoading: isVerifyOtpUsecaseLoading,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildResendOtpWidget(
    BuildContext context,
    ForgotPasswordViewmodel viewmodel,
  ) {
    bool isResendOtpUsecaseLoading = viewmodel.requestOtpUseCase.isLoading;

    final appColors = context.appColors;

    return GestureDetector(
      onTap: () => _resendOtp(viewmodel),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: AuthStrings.didntReceiveOtp,
          style: Theme.of(context)
              .textTheme
              .bodyText
              .copyWith(color: appColors.textInverse),
          children: [
            if (isResendOtpUsecaseLoading)
              WidgetSpan(
                child: SizedBox(
                  width: 20.h,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(appColors.bgPrimaryMain),
                  ),
                ),
              )
            else
              TextSpan(
                text: AuthStrings.resendOtpBtnText,
                style: Theme.of(context)
                    .textTheme
                    .bodyText
                    .copyWith(color: appColors.textPrimary),
              ),
          ],
        ),
      ),
    );
  }

  _resendOtp(ForgotPasswordViewmodel viewmodel) async {
    await viewmodel.requestOtp(widget.phoneNumber);

    String message = "";

    if (viewmodel.requestOtpUseCase.hasCompleted &&
        viewmodel.requestOtpUseCase.data != null) {
      message = viewmodel.requestOtpUseCase.data?.message ?? "Otp code sent.";
      showToast(
        context,
        isSuccess: true,
        message,
      );
    } else {
      message =
          viewmodel.requestOtpUseCase.exception ?? ErrorMessages.defaultError;
      showToast(
        context,
        isSuccess: false,
        message,
      );
    }
  }

  void _onRequestOTP(ForgotPasswordViewmodel viewmodel) async {
    if (validate()) {
      await viewmodel.verifyOtp(
        phoneNumber: widget.phoneNumber,
        otp: _otpFormKey
            .currentState!.value[AuthTextfieldConstant.forgotPasswordOtp],
      );

      if (viewmodel.verifyOtpUseCase.hasCompleted &&
          viewmodel.verifyOtpUseCase.data != null) {
        String uuId = viewmodel.verifyOtpUseCase.data?.uuId.toString() ?? '';
        context.goNamed(AppRoute.setPasswordForgot.name, extra: {
          'phoneNumber': widget.phoneNumber,
          'uuId': uuId,
        });
      } else {
        String errorMessage =
            viewmodel.verifyOtpUseCase.exception ?? ErrorMessages.defaultError;
        if (!context.mounted) return;
        showToast(
          context,
          isSuccess: false,
          errorMessage,
        );
      }
    }
  }

  String _getVerificationCodeDescription() {
    return "${AuthStrings.verifyOtpDescription} ${PhoneUtils.maskPhoneNumber(widget.phoneNumber)}.";
  }

  bool validate() {
    final currentState = _otpFormKey.currentState;

    if (currentState != null && currentState.validate()) {
      currentState.save();
      return true;
    }

    return false;
  }
}
