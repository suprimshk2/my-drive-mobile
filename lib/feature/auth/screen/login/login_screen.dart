import 'dart:io';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/di/service_locator.dart' as di;
import 'package:mydrivenepal/feature/auth/constants/constants.dart';
import 'package:mydrivenepal/feature/auth/data/model/apple_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/google_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_request_model.dart';

import 'package:mydrivenepal/feature/auth/screen/biometric/biometric_screen.dart';
import 'package:mydrivenepal/feature/auth/screen/biometric/biometric_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/login/developer_option.dart';
import 'package:mydrivenepal/feature/auth/screen/login/login_viewmodel.dart';
import 'package:mydrivenepal/feature/auth/screen/widgets/banner_widget.dart';
import 'package:mydrivenepal/feature/auth/service/google_sign_service.dart';
import 'package:mydrivenepal/feature/banner/banner_viewmodel.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_response_model.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:mydrivenepal/feature/profile/constants/profile_strings.dart';

import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/shared/constant/route_names.dart';
import 'package:mydrivenepal/shared/enum/common.dart';
import 'package:mydrivenepal/shared/helper/biometric_helper.dart';
import 'package:mydrivenepal/shared/helper/device_info_helper.dart';
import 'package:mydrivenepal/shared/helper/notification_helper.dart';
import 'package:mydrivenepal/shared/helper/platform_helper.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
// import 'package:mydrivenepal/shared/helper/notification_helper.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/shared/util/response.dart';
import 'package:mydrivenepal/shared/util/toast.dart';
import 'package:mydrivenepal/widget/alert/custom_dialog_widget.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_filled_button_widget.dart';

import 'package:mydrivenepal/widget/button/variants/text_button_widget.dart';
import 'package:mydrivenepal/widget/checkbox/custom_checkbox.dart';

import 'package:mydrivenepal/widget/image/image_widget.dart';
import 'package:mydrivenepal/widget/info/info_container.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import 'package:mydrivenepal/widget/text-field/text_field_widget.dart';
import 'package:mydrivenepal/widget/text-field/variants/password_text_field_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../di/remote_config_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel _loginScreenViewmodel = locator<LoginViewModel>();
  final BiometricViewModel _biometricViewModel = locator<BiometricViewModel>();

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   initializeData();
    // });
  }

  void initializeData() async {
    await _biometricViewModel.initBiometricStatus();

    await di.locator<BannerViewModel>().fetchBanners();
    await _loginScreenViewmodel.getRememberDetails();

    _loginFormKey.currentState?.fields[AuthTextfieldConstant.userName]
        ?.didChange(_loginScreenViewmodel.rememberMeData);

    _loginScreenViewmodel.getVersion();
  }

  final RemoteConfigService _remoteConfigService =
      locator<RemoteConfigService>();

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _loginFormKey = GlobalKey<FormBuilderState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  bool _validateForm() {
    final currentState = _loginFormKey.currentState;

    if (currentState != null && currentState.validate()) {
      currentState.save();
      return true;
    }

    return false;
  }

  void observeAppleResponse(LoginViewModel authViewModel) {
    if (authViewModel.appleLoginUseCase.hasCompleted) {
      // authGlobalStateProvider.checkLoginStatus();
      // authGlobalStateProvider.getUserDate();
      Navigator.of(context).pop();
      showToast(context, 'Login Successful', isSuccess: true);
    } else {
      showToast(context, authViewModel.appleLoginUseCase.exception!,
          isSuccess: false);
    }
  }

  void observeResponse(LoginViewModel authViewModel) {
    if (authViewModel.loginUseCase.hasCompleted) {
      _loginFormKey.currentState!.reset();
      // authGlobalStateProvider.checkLoginStatus();
      // authGlobalStateProvider.getUserDate();
      Navigator.of(context).pop();
      showToast(context, 'Login Successful', isSuccess: true);
    } else {
      showToast(context, authViewModel.loginUseCase.exception!,
          isSuccess: false);
    }
  }

  Future<AppleLoginRequest> mapPayload(
      AuthorizationCredentialAppleID credential) async {
    final String notificationToken = await NotificationHelper().requestToken();
    NotificationHelper().refreshToken();
    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();

    return AppleLoginRequest(
      firstName: credential.givenName ?? "FirstName",
      lastName: credential.familyName ?? "LastName",
      code: credential.authorizationCode,
      deviceNotification: DeviceNotificationModel(
        deviceId: deviceInfo.deviceId,
        notificationToken: notificationToken,
        platform: PlatformHelper.platform.name,
      ),
    );
  }

  Future<void> _signInWithApple(LoginViewModel authViewModel) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
          AppleIDAuthorizationScopes.email,
        ],
      );
      final mapCredentaial = await mapPayload(credential);

      await authViewModel.appleLogin(mapCredentaial);

      observeAppleResponse(authViewModel);
    } catch (e) {
      print('Error signing in with Apple: $e');
      showToast(context, 'Something went wrong', isSuccess: false);
    }
  }

  void observeGoogleResponse(LoginViewModel authViewModel) {
    if (authViewModel.googleLoginUseCase.hasCompleted) {
      // authGlobalStateProvider.checkLoginStatus();
      // authGlobalStateProvider.getUserDate();
      context.go(RouteNames.userMode);
      showToast(context, 'Login Successful', isSuccess: true);
    } else {
      GoogleSignInService.signOutGoogle();

      showToast(context, authViewModel.googleLoginUseCase.exception!,
          isSuccess: false);
    }
  }

  Future<void> _signInWithGoogle(LoginViewModel loginViewModel) async {
    try {
      final googleUser = await GoogleSignInService.signInWithGoogle();
      if (googleUser == null) return null;

      await googleUser.clearAuthCache();

      final googleAuth = await googleUser.authentication;

      await loginViewModel.googleLogin(googleAuth.accessToken ?? '');

      observeGoogleResponse(loginViewModel);
    } catch (e) {
      showToast(context, 'Something went wrong', isSuccess: false);
    }
  }

  Widget _showDeveloperOption() {
    final appColors = context.appColors;

    if (dotenv.env["ENV"] != "PROD") {
      return Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            MaterialRoutePush(context, const DeveloperOption());
          },
          child: Container(
            padding: EdgeInsets.all(Dimens.spacing_6),
            decoration: BoxDecoration(
                color: appColors.bgPrimaryMain,
                borderRadius: BorderRadius.circular(50)),
            child: Icon(
              Icons.settings,
              color: appColors.gray.subtle,
              size: 18,
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    // final remoteConfig = _remoteConfigService.whiteLabelConfig;
    final envValues = dotenv.env;
    final appColors = context.appColors;

    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => _loginScreenViewmodel,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginViewModel>(
            create: (_) => _loginScreenViewmodel,
          ),
          ChangeNotifierProvider<BiometricViewModel>(
            create: (context) => _biometricViewModel,
          ),
        ],
        child: Builder(builder: (context) {
          return Consumer<LoginViewModel>(
              builder: (context, loginViewModelValue, _) {
            final hasError = loginViewModelValue.loginUseCase.hasError;
            var appVersion = loginViewModelValue.appVersion.data;
            return ScaffoldWidget(
              padding: 0,
              top: 0,
              bottom: 0,
              showAppbar: false,
              useSafeArea: false,
              resizeToAvoidBottomInset: false,
              showTransparentStatusBar: true,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 0.64.sh,
                          width: double.infinity,
                          child: ImageWidget(
                            imagePath: ImageConstants.IC_BANNER,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  appColors.bgSecondaryMain
                                      .withValues(alpha: 0.9),
                                  AppColors.transparent,
                                  AppColors.transparent,
                                ],
                                stops: [0.0, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Consumer<BannerViewModel>(
                        builder: (context, bannerViewModel, _) {
                      final bannersUseCase = bannerViewModel.bannersUseCase;
                      final hasBanner = bannersUseCase.hasData &&
                          (bannersUseCase.data?.rows.isNotEmpty ?? false);
                      return ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Container(
                            height: hasBanner ? 0.75.sh : 0.61.sh,
                            decoration: BoxDecoration(
                              color: appColors.bgGraySubtle
                                  .withValues(alpha: 0.79),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Dimens.radius_default),
                                topRight:
                                    Radius.circular(Dimens.radius_default),
                              ),
                            ),
                            child: SingleChildScrollView(
                              reverse: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: FormBuilder(
                                      key: _loginFormKey,
                                      autovalidateMode: _autoValidateMode,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(height: 16.h),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     // Text(
                                          //     //   AuthStrings.memberLogin,
                                          //     //   style: Theme.of(context)
                                          //     //       .textTheme
                                          //     //       .pageTitle
                                          //     //       .copyWith(
                                          //     //           color: appColors
                                          //     //               .textInverse),
                                          //     // ),
                                          //     _showDeveloperOption(),
                                          //   ],
                                          // ),
                                          // SizedBox(height: 16.h),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                            child: hasError
                                                ? Column(
                                                    key: ValueKey<bool>(
                                                        hasError),
                                                    children: [
                                                      InfoContainer(
                                                        title:
                                                            loginViewModelValue
                                                                .loginUseCase
                                                                .exception!,
                                                        type: InfoType.warning,
                                                      ),
                                                      SizedBox(height: 16.h),
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                          TextFieldWidget(
                                            initialValue: loginViewModelValue
                                                .rememberMeData,
                                            focusNode: _userNameFocusNode,
                                            nextNode: _passwordFocusNode,
                                            textInputAction:
                                                TextInputAction.next,
                                            prefixIcon: Icons.person_2_outlined,
                                            name:
                                                AuthTextfieldConstant.userName,
                                            label: envValues["USERNAME_LABEL"]!,
                                            isRequired: true,
                                            hintText:
                                                envValues["USERNAME_HINT_TXT"]!,
                                          ),
                                          const SizedBox(
                                              height: Dimens.spacing_small),
                                          PasswordTextFieldWidget(
                                            focusNode: _passwordFocusNode,
                                            prefixIcon: Icons.lock_outline,
                                            name:
                                                AuthTextfieldConstant.password,
                                            label: AuthStrings.password,
                                            hintText:
                                                AuthStrings.passwordHintText,
                                            isRequired: true,
                                            onFieldSubmitted: (_) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                          ),
                                          const SizedBox(
                                              height: Dimens.spacing_default),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  loginViewModelValue
                                                      .setRememberMe(
                                                    !loginViewModelValue
                                                        .isRememberMe,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    CustomCheckbox(
                                                      value: loginViewModelValue
                                                          .isRememberMe,
                                                      onChanged: (bool? value) {
                                                        loginViewModelValue
                                                            .setRememberMe(
                                                                value ?? false);
                                                      },
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            Dimens.spacing_6),
                                                    TextWidget(
                                                      text: AuthStrings
                                                          .rememberMe,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText
                                                          .copyWith(
                                                              color: appColors
                                                                  .textInverse),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  context.push(RouteNames
                                                      .forgotPassword);
                                                },
                                                child: TextWidget(
                                                  text: AuthStrings
                                                      .forgotPassword,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText
                                                      .copyWith(
                                                          color: appColors
                                                              .textInverse),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 20.h),
                                          Consumer<BiometricViewModel>(builder:
                                              (context, biometricViewModel, _) {
                                            final isLoading =
                                                loginViewModelValue.loginUseCase
                                                        .isLoading ||
                                                    biometricViewModel
                                                        .biometricLoginUseCase
                                                        .isLoading;

                                            bool hasBiometricSetup =
                                                biometricViewModel
                                                    .isBiometricSetup;

                                            return RoundedFilledButtonWidget(
                                              context: context,
                                              isLoading: isLoading,
                                              label: AuthStrings.login,
                                              onPressed: () async {
                                                context.go(RouteNames.userMode);
                                                // if (_validateForm()) {
                                                //   FocusScope.of(context)
                                                //       .unfocus();

                                                //   setState(() {
                                                //     _autoValidateMode =
                                                //         AutovalidateMode
                                                //             .disabled;
                                                //   });

                                                //   final formValues =
                                                //       _loginFormKey
                                                //           .currentState!.value;
                                                //   final userName = formValues[
                                                //       AuthTextfieldConstant
                                                //           .userName];
                                                //   final password = formValues[
                                                //       AuthTextfieldConstant
                                                //           .password];

                                                //   final loginRequestModel =
                                                //       LoginRequestModel(
                                                //     password: password,
                                                //     userName: userName,
                                                //     rememberMe:
                                                //         loginViewModelValue
                                                //             .isRememberMe,
                                                //   );

                                                //   await loginViewModelValue
                                                //       .login(loginRequestModel);

                                                //   observeLoginResponse(
                                                //       biometricViewModel,
                                                //       loginViewModelValue);
                                                // } else {
                                                //   setState(() {
                                                //     _autoValidateMode =
                                                //         AutovalidateMode
                                                //             .onUserInteraction;
                                                //   });
                                                // }
                                              },
                                              icon: hasBiometricSetup
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        onBiometricLogin(
                                                            biometricViewModel,
                                                            loginViewModelValue);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            Dimens.spacing_8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: appColors
                                                              .primary.subtle,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: ImageWidget(
                                                          imagePath:
                                                              ImageConstants
                                                                  .IC_FINGERPRINT,
                                                          height: 16.w,
                                                          width: 16.w,
                                                          color: appColors
                                                              .primary.main,
                                                          isSvg: true,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _buildOtherLogins(loginViewModelValue),
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButtonWidget(
                                              label: AuthStrings.termsOfUse,
                                              onPressed: () {
                                                launchExternalUrl(
                                                    envValues["TERMS_URL"]!);
                                              },
                                              fontSize: 12.sp,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.spacing_2),
                                              child: Text(
                                                '|',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: appColors
                                                            .textInverse),
                                              ),
                                            ),
                                            TextButtonWidget(
                                              label: AuthStrings.privacyPolicy,
                                              onPressed: () {
                                                launchExternalUrl(
                                                    envValues["POLICY_URL"]!);
                                              },
                                              fontSize: 12.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        // TextWidget(
                                        //   text: _getAppVersion(
                                        //       appVersion: appVersion,
                                        //       envValues: envValues),
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .bodyTextSmall
                                        //       .copyWith(
                                        //           color: appColors.textInverse),
                                        // ),
                                        SizedBox(height: 18.h),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom /
                                        2.5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          });
        }),
      ),
    );
  }

  Widget _buildOtherLogins(LoginViewModel authViewModel) {
    return Column(
      children: [
        TextWidget(
          text: 'OR',
          style: Theme.of(context).textTheme.bodyText.copyWith(
                color: AppColors.white,
              ),
        ),
        if (Platform.isIOS) ...[
          // RoundedOutlinedButtonWidget(
          //   isLoading: authViewModel.appleLoginUseCase.isLoading,
          //   onPressed: () {
          //     _signInWithApple(authViewModel);
          //   },
          //   loadingColor: AppColors.gray1000,
          //   label: 'Continue with Apple',
          //   borderWidth: 1.3,
          //   borderColor: AppColors.gray1000,
          //   textColor: AppColors.gray1000,
          //   iconSpacing: 15,
          //   icon: const ImageWidget(
          //     width: 20,
          //     height: 20,
          //     imagePath: ImageConstants.APPLE_LOGIN,
          //     isSvg: true,
          //   ),
          // ),
          TextButton(
            style: TextButton.styleFrom(
              fixedSize: Size(double.infinity, 20.h),
              backgroundColor: AppColors.black,
              padding: EdgeInsets.zero,
            ),
            onPressed: authViewModel.appleLoginUseCase.isLoading
                ? null
                : () {
                    _signInWithApple(authViewModel);
                  },
            child: authViewModel.appleLoginUseCase.isLoading
                ? Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: SvgPicture.asset(
                      width: 200.w,
                      ImageConstants.APPLE_LOGIN,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
          SizedBox(height: Dimens.spacing_default),
        ],
        // RoundedOutlinedButtonWidget(
        //   isLoading: authViewModel.googleLoginUseCase.isLoading,
        //   onPressed: () {
        //     _signInWithGoogle(authViewModel);
        //   },
        //   loadingColor: AppColors.gray1000,
        //   label: 'Continue with Google',
        //   borderWidth: 1.3,
        //   borderColor: AppColors.gray1000,
        //   textColor: AppColors.gray1000,
        //   iconSpacing: 15,
        //   icon: ImageWidget(
        //     width: 20,
        //     height: 20,
        //     imagePath: ImageConstants.GOOGLE_LOGIN,
        //     isSvg: true,
        //   ),
        // ),
        TextButton(
          style: TextButton.styleFrom(
            fixedSize: Size(double.infinity, 20.h),
            backgroundColor: AppColors.transparent,
            padding: EdgeInsets.zero,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(Dimens.spacing_6),
            //   side: BorderSide(
            //     width: 1,
            //     color: Color(0xFF131314),
            //   ),
            // ),
          ),
          onPressed: authViewModel.googleLoginUseCase.isLoading
              ? null
              : () {
                  _signInWithGoogle(authViewModel);
                },
          child: authViewModel.googleLoginUseCase.isLoading
              ? Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: SvgPicture.asset(
                    width: 200.w,
                    ImageConstants.GOOGLE_LOGIN,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
      ],
    );
  }

  String _getAppVersion({
    AppVersionModel? appVersion,
    required Map<String, String> envValues,
  }) {
    if (appVersion == null) return '';

    String environment = envValues["ENV"] ?? '';

    bool isProduction = environment == 'PROD';

    String environmentText = isProduction ? '' : '($environment)';

    return "${ProfileStrings.version}$environmentText ${appVersion.version}";
  }

  void _showPasswordExpiredDailog(String code) {
    final appColors = context.appColors;

    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: AuthStrings.passwordExpiredTitle,
          description: AuthStrings.passwordExpiredDescription,
          iconPath: ImageConstants.IC_WARNING_ROUND,
          iconColor: appColors.error.main,
          primaryButtonLabel: AuthStrings.changePasswordBtnLabel,
          onPrimaryButtonPressed: () {
            context.pushNamed(AppRoute.resetPassword.name, extra: {
              'code': code,
            });
          },
          secondaryButtonLabel: AuthStrings.cancelBtnText,
          onSecondaryButtonPressed: () {
            context.pop();
          },
        );
      },
    );
  }

  void observeLoginResponse(
    BiometricViewModel biometricViewModel,
    LoginViewModel loginViewModel,
  ) async {
    if (loginViewModel.loginUseCase.hasCompleted) {
      final data = loginViewModel.loginUseCase.data;

      if (data != null) {
        if (data.isSuccess) {
          _loginFormKey.currentState!.reset();

          final bool isBiometricSupported =
              await BiometricHelper.isBiometricSupported();

          if (isBiometricSupported && !biometricViewModel.isBiometricSetup) {
            Navigator.of(context).push(
              //TODO: refactor navigation later
              MaterialPageRoute(
                builder: (_) => BiometricScreen(),
              ),
            );
          } else {
            context.goNamed(AppRoute.landing.name);
          }
        } else {
          _showPasswordExpiredDailog(data.errorData?.code ?? '');
        }
      }
    }
  }

  void onBiometricLogin(
    BiometricViewModel biometricViewModel,
    LoginViewModel loginViewModel,
  ) async {
    final bool didAuthenticate =
        await BiometricHelper.authenticate('Please authenticate to login.');
    if (didAuthenticate) {
      await biometricViewModel.biometricLogin();
      observeBiometricLoginResponse(biometricViewModel, loginViewModel);
    }
  }

  void observeBiometricLoginResponse(BiometricViewModel biometricViewModel,
      LoginViewModel loginViewModel) async {
    if (biometricViewModel.biometricLoginUseCase.hasCompleted) {
      final data = biometricViewModel.biometricLoginUseCase.data;

      if (data != null) {
        if (data.isSuccess) {
          context.goNamed(AppRoute.landing.name);
        } else {
          _showPasswordExpiredDailog(data.errorData?.code ?? '');
        }
      }
    } else {
      showToast(context, biometricViewModel.biometricLoginUseCase.exception!,
          isSuccess: false);
    }
  }
}
