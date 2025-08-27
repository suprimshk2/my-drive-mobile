import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/auth/constants/constants.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';
import 'package:mydrivenepal/feature/auth/screen/user-activation/user_activation_viewmodel.dart';
import 'package:mydrivenepal/navigation/navigation.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/error_states/generic_error_widget.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WelcomeToSwaddleScreen extends StatefulWidget {
  final String code;

  const WelcomeToSwaddleScreen({
    super.key,
    required this.code,
  });

  @override
  State<WelcomeToSwaddleScreen> createState() => _WelcomeToSwaddleScreenState();
}

class _WelcomeToSwaddleScreenState extends State<WelcomeToSwaddleScreen> {
  final UserActivationViewmodel _userActivationViewmodel =
      locator<UserActivationViewmodel>();

  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  Future<void> getInitialData() async {
    await _userActivationViewmodel.verifyCode(code: widget.code);
  }

  @override
  Widget build(BuildContext context) {
    final logoPath = dotenv.env["LOGO_PATH"]!;

    final appColors = context.appColors;

    return ChangeNotifierProvider(
      create: (context) => _userActivationViewmodel,
      child: ScaffoldWidget(
        showAppbar: false,
        child: Consumer<UserActivationViewmodel>(
          builder: (context, viewmodel, _) {
            var verifyCodeUseCase = viewmodel.verifyCodeUseCase.data;

            var name = verifyCodeUseCase?.user?.firstName ?? '';

            return ResponseBuilder<VerifyCodeResponse>(
              onRetry: () => getInitialData(),
              onError: (error) {
                return GenericErrorWidget(
                  buttonTxt: AuthStrings.goToLogin,
                  onPressed: () => context.goNamed(
                    AppRoute.login.name,
                  ),
                  customTitle: error,
                  customMessage:
                      AuthStrings.userActivationCodeExpiryErrorMessage,
                );
              },
              response: viewmodel.verifyCodeUseCase,
              onData: (data) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: 30.h),
                    Center(
                      child: Image.asset(
                        logoPath,
                        fit: BoxFit.contain,
                        width: 0.5.sw,
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: Column(
                        children: [
                          TextWidget(
                            text: _getWelcomeText(name: name),
                            style: Theme.of(context)
                                .textTheme
                                .largeTitle
                                .copyWith(color: appColors.textInverse),
                          ),
                          SizedBox(height: 10.h),
                          TextWidget(
                            text: AuthStrings.welcomeToSwaddleDescription,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText
                                .copyWith(color: appColors.textSubtle),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    RoundedFilledButtonWidget(
                      context: context,
                      label: AuthStrings.setPasswordBtnLabel,
                      onPressed: () => _onNavigateToSetPasswordScreen(context,
                          user: verifyCodeUseCase?.user),
                    ),
                    SizedBox(height: 10.h),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getWelcomeText({required String name}) {
    return '${AuthStrings.welcomeToSwaddle} $name';
  }

  _onNavigateToSetPasswordScreen(
    BuildContext context, {
    required User? user,
  }) {
    context.pushNamed(AppRoute.setPasswordForActivation.name, extra: {
      'code': widget.code,
      'user': user,
    });
  }
}
