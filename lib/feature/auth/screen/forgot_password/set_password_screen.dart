import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/auth/constants/constants.dart';

import 'package:mydrivenepal/feature/auth/screen/forgot_password/forgot_password_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/widgets/password_rule_widget.dart';
import 'package:mydrivenepal/provider/password_validator_viewmodel.dart';

import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SetPasswordScreen extends StatefulWidget {
  final String uuId;
  final String phoneNumber;

  const SetPasswordScreen({
    super.key,
    required this.uuId,
    required this.phoneNumber,
  });

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final ForgotPasswordViewmodel _forgotPasswordViewModel =
      locator<ForgotPasswordViewmodel>();

  final PasswordValidatorViewModel _passwordValidatorViewModel =
      locator<PasswordValidatorViewModel>();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      appbarTitle: AuthStrings.setPasswordTitle,
      padding: Dimens.spacing_8,
      resizeToAvoidBottomInset: false,
      showBackButton: true,
      onPressedIcon: () => context.goNamed(AppRoute.login.name),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => _forgotPasswordViewModel),
          ChangeNotifierProvider(
              create: (context) => _passwordValidatorViewModel),
        ],
        child: Consumer<ForgotPasswordViewmodel>(builder: (
          context,
          forgotPasswordViewModel,
          _,
        ) {
          bool isLoading = forgotPasswordViewModel.setPasswordUseCase.isLoading;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              FormBuilder(
                key: _formKey,
                autovalidateMode: _autoValidateMode,
                child: Column(
                  children: [
                    PasswordTextFieldWidget(
                      nextNode: _confirmPasswordFocusNode,
                      textInputAction: TextInputAction.next,
                      name: AuthTextfieldConstant.forgotPassword,
                      label: AuthStrings.password,
                      isRequired: true,
                      autoFocus: true,
                      enabled: !isLoading,
                      hintText: AuthStrings.passwordHintText,
                      onChanged: (value) {
                        _passwordValidatorViewModel.password = value ?? "";
                      },
                    ),
                    SizedBox(height: Dimens.spacing_8),
                    PasswordTextFieldWidget(
                        focusNode: _confirmPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        name: AuthTextfieldConstant.confirmPassword,
                        label: AuthStrings.confirmPassword,
                        isRequired: true,
                        autoFocus: true,
                        enabled: !isLoading,
                        hintText: AuthStrings.confirmPasswordHintText,
                        onChanged: (value) {
                          _passwordValidatorViewModel.confirmPassword =
                              value ?? "";
                        },
                        onFieldSubmitted: (value) =>
                            _onSubmitPassword(forgotPasswordViewModel)),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              TextWidget(
                text: AuthStrings.rulesForChangingPassword,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText.copyWith(
                      color: appColors.textInverse,
                    ),
              ),
              SizedBox(height: 30.h),
              Consumer<PasswordValidatorViewModel>(
                  builder: (context, passwordValidatorViewModel, child) {
                bool isPasswordStrong =
                    passwordValidatorViewModel.isPasswordStrong;
                bool isPasswordMatch =
                    passwordValidatorViewModel.isPasswordMatch;
                bool passwordHasPersonalInfo =
                    passwordValidatorViewModel.passwordHasPersonalInfo;
                bool passwordIsGloballyBanned =
                    passwordValidatorViewModel.passwordIsGloballyBanned;
                bool passwordIsUsed = passwordValidatorViewModel.passwordIsUsed;

                bool isPasswordValid =
                    passwordValidatorViewModel.isPasswordValid &&
                        isPasswordMatch;

                return Column(
                  children: [
                    PasswordRuleWidget(
                      rule: AuthStrings.passwordStrengthRule,
                      isChecked: isPasswordStrong,
                    ),
                    PasswordRuleWidget(
                      rule: AuthStrings.personalInfoRule,
                      isChecked: !passwordHasPersonalInfo,
                    ),
                    PasswordRuleWidget(
                      rule: AuthStrings.bannedPasswordRule,
                      isChecked: !passwordIsGloballyBanned,
                    ),
                    PasswordRuleWidget(
                      rule: AuthStrings.usedPasswordRule,
                      isChecked: !passwordIsUsed,
                    ),
                    PasswordRuleWidget(
                      rule: AuthStrings.confirmPasswordRule,
                      isChecked: isPasswordMatch,
                    ),
                    SizedBox(height: 30.h),
                    RoundedFilledButtonWidget(
                      context: context,
                      enabled: isPasswordValid,
                      isLoading: isLoading,
                      label: AuthStrings.submitPasswordBtnLabel,
                      onPressed: () =>
                          _onSubmitPassword(forgotPasswordViewModel),
                    )
                  ],
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    _passwordValidatorViewModel.uuId = widget.uuId;
    super.initState();
  }

  void _onSubmitPassword(
    ForgotPasswordViewmodel forgotPasswordViewModel,
  ) async {
    if (validate()) {
      String password =
          _formKey.currentState!.value[AuthTextfieldConstant.forgotPassword];

      String confirmPassword =
          _formKey.currentState!.value[AuthTextfieldConstant.confirmPassword];

      // todo: remove this later.
      if (password != confirmPassword) {
        showToast(context, isSuccess: false, "Passwords do not match");
        return;
      }

      await _forgotPasswordViewModel.setPassword(
        password: password,
        phoneNumber: widget.phoneNumber,
      );

      if (forgotPasswordViewModel.setPasswordUseCase.hasCompleted &&
          forgotPasswordViewModel.setPasswordUseCase.data != null) {
        if (!context.mounted) return;
        context.goNamed(
          AppRoute.success.name,
          extra: {'isPasswordSet': true},
        );
      } else {
        String errorMessage =
            forgotPasswordViewModel.setPasswordUseCase.exception ??
                ErrorMessages.defaultError;
        if (!context.mounted) return;
        showToast(context, isSuccess: false, errorMessage);
      }
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  bool validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }
}
