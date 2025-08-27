import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/di.dart';
import 'package:mydrivenepal/feature/auth/constants/constants.dart';
import 'package:mydrivenepal/feature/auth/screen/forgot_password/forgot_password_viewmodel.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/button/variants/back_navigation_button.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneNumberForm = GlobalKey<FormBuilderState>();

  final ForgotPasswordViewmodel forgotPwViewmodel =
      locator<ForgotPasswordViewmodel>();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ChangeNotifierProvider(
      create: (context) => forgotPwViewmodel,
      child: ScaffoldWidget(
        appbarTitle: AuthStrings.forgotPasswordTitle,
        padding: Dimens.spacing_8,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_8),
              child: TextWidget(
                text: AuthStrings.requestOTPTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText
                    .copyWith(color: appColors.textInverse),
              ),
            ),
            SizedBox(height: 30.h),
            FormBuilder(
              key: _phoneNumberForm,
              child: TextFieldWidget(
                isRequired: true,
                inputFormat: [TextFieldMaskings.phoneNumberMasking],
                name: AuthTextfieldConstant.phoneNumber,
                textInputAction: TextInputAction.done,
                label: AuthStrings.phoneNumber,
                textInputType: TextInputType.phone,
                hintText: AuthStrings.phoneNumberHintText,
                errorText: 'Invalid phone number',
                validator: [
                  FormBuilderValidators.minLength(14,
                      errorText: 'Invalid phone number'),
                  FormBuilderValidators.maxLength(14,
                      errorText: 'Invalid phone number'),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Consumer<ForgotPasswordViewmodel>(
                builder: (context, viewmodel, child) {
              bool isLoading = viewmodel.requestOtpUseCase.isLoading;

              return RoundedFilledButtonWidget(
                context: context,
                isLoading: isLoading,
                label: AuthStrings.requestOTP,
                onPressed: () {
                  _onRequestOTP(viewmodel);
                },
              );
            }),
            SizedBox(height: 30.h),
            BackNavigationWidget(buttonLabel: AuthStrings.backToLogin),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  bool validate() {
    if (_phoneNumberForm.currentState!.validate()) {
      _phoneNumberForm.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  void _onRequestOTP(ForgotPasswordViewmodel viewmodel) async {
    if (validate()) {
      String formFieldNumber = _phoneNumberForm
          .currentState!.value[AuthTextfieldConstant.phoneNumber];

      String number = PhoneUtils.getCleanedPhoneNumber(formFieldNumber);

      await viewmodel.requestOtp(number);

      if (viewmodel.requestOtpUseCase.hasCompleted &&
          viewmodel.requestOtpUseCase.data != null) {
        if (!context.mounted) return;
        context.pushNamed(AppRoute.otpVerification.name, extra: {
          'phoneNumber': number,
        });
      } else {
        String errorMessage =
            viewmodel.requestOtpUseCase.exception ?? ErrorMessages.defaultError;
        if (!context.mounted) return;
        showToast(
          context,
          isSuccess: false,
          errorMessage,
        );
      }
    }
  }
}
