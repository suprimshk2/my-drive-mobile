import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/auth/constants/constants.dart';

import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';
import 'package:mydrivenepal/feature/auth/screen/login/login_screen.dart';
import 'package:mydrivenepal/feature/auth/screen/user-activation/user_activation_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/widgets/password_rule_widget.dart';
import 'package:mydrivenepal/provider/password_validator_viewmodel.dart';

import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_filled_button_widget.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import 'package:mydrivenepal/widget/text-field/text_field.dart';
import 'package:mydrivenepal/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SetPasswordToActivateScreen extends StatefulWidget {
  final User? user;
  final String code;

  const SetPasswordToActivateScreen({
    super.key,
    this.user,
    required this.code,
  });

  @override
  State<SetPasswordToActivateScreen> createState() =>
      _SetPasswordToActivateScreenState();
}

class _SetPasswordToActivateScreenState
    extends State<SetPasswordToActivateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final PasswordValidatorViewModel _passwordValidatorViewModel =
      locator<PasswordValidatorViewModel>();

  final UserActivationViewmodel _userActivationViewmodel =
      locator<UserActivationViewmodel>();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  String appName = dotenv.env['APP_NAME'] ?? '';

  @override
  void initState() {
    super.initState();
    _passwordValidatorViewModel.uuId = widget.user?.userId?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    bool isAppHolista = appName.toLowerCase() == 'holista';

    String username =
        isAppHolista ? widget.user?.email ?? '' : widget.user?.phone ?? '';

    final envValues = dotenv.env;

    final appColors = context.appColors;

    return ScaffoldWidget(
      appbarTitle: AuthStrings.setPasswordTitle,
      padding: Dimens.spacing_8,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => _passwordValidatorViewModel),
          ChangeNotifierProvider(create: (context) => _userActivationViewmodel),
        ],
        child: Consumer<UserActivationViewmodel>(
            builder: (context, userActivationViewmodel, child) {
          bool isLoading =
              userActivationViewmodel.setPasswordForActivationUsecase.isLoading;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                FormBuilder(
                  key: _formKey,
                  autovalidateMode: _autoValidateMode,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        readOnly: true,
                        initialValue: username,
                        name: AuthTextfieldConstant.userName,
                        label: envValues["USERNAME_LABEL"]!,
                        isRequired: true,
                        hintText: envValues["USERNAME_HINT_TXT"]!,
                      ),
                      SizedBox(height: Dimens.spacing_8),
                      PasswordTextFieldWidget(
                        nextNode: _confirmPasswordFocusNode,
                        textInputAction: TextInputAction.next,
                        name: AuthTextfieldConstant.forgotPassword,
                        label: AuthStrings.password,
                        isRequired: true,
                        autoFocus: true,
                        // enabled: !isLoading,
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
                        // enabled: !isLoading,
                        hintText: AuthStrings.confirmPasswordHintText,
                        onChanged: (value) {
                          _passwordValidatorViewModel.confirmPassword =
                              value ?? "";
                        },
                      ),
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
                  bool passwordIsUsed =
                      passwordValidatorViewModel.passwordIsUsed;

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
                            _onSubmitPassword(userActivationViewmodel),
                      )
                    ],
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _onSubmitPassword(
    UserActivationViewmodel userActivationViewmodel,
  ) async {
    if (validate()) {
      await userActivationViewmodel.setPasswordForActivation(
        code: widget.code,
        email: widget.user?.email ?? '',
        id: widget.user?.userId?.toInt() ?? 0,
        password: _passwordValidatorViewModel.password,
      );

      if (userActivationViewmodel
              .setPasswordForActivationUsecase.hasCompleted &&
          userActivationViewmodel.setPasswordForActivationUsecase.data !=
              null) {
        context.goNamed(
          AppRoute.success.name,
          extra: {'isPasswordSet': true},
        );
      } else {
        String message =
            userActivationViewmodel.setPasswordForActivationUsecase.exception ??
                ErrorMessages.defaultError;
        showToast(
          context,
          message,
          isSuccess: false,
        );
      }
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
