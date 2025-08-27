import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/feature/auth/screen/biometric/biometric_viewmodel.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';

import '../../../../di/service_locator.dart';
import '../../constants/constants.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final BiometricViewModel _biometricViewModel = locator<BiometricViewModel>();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ChangeNotifierProvider<BiometricViewModel>(
      create: (context) => _biometricViewModel,
      child: ScaffoldWidget(
        showAppbar: true,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageWidget(
                    imagePath: Platform.isAndroid
                        ? ImageConstants.IC_FINGERPRINT
                        : ImageConstants.IC_FACE_ID,
                    color: appColors.bgPrimaryMain,
                    height: 80.h,
                    width: 80.h,
                    isSvg: true,
                  ),
                  const SizedBox(height: Dimens.spacing_extra_large),
                  Text(
                    'Biometric Setup',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: appColors.textInverse),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Dimens.spacing_extra_large),
                  Text(
                    'Setup your biometric to secure account',
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                        fontWeight: FontWeight.normal,
                        color: appColors.textInverse),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Consumer<BiometricViewModel>(
              builder: (context, biometricViewModel, child) {
                return Column(
                  children: [
                    RoundedFilledButtonWidget(
                      context: context,
                      label: AuthStrings.setup_biometric,
                      onPressed: onBiometricSetup,
                      isLoading:
                          biometricViewModel.biometricSetupUseCase.isLoading,
                    ),
                    const SizedBox(height: Dimens.spacing_extra_large),
                    TextButtonWidget(
                      onPressed:
                          biometricViewModel.biometricSetupUseCase.isLoading
                              ? null
                              : onPressSetupLater,
                      label: AuthStrings.setup_later,
                    ),
                    const SizedBox(height: Dimens.spacing_extra_large),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  onBiometricSetup() async {
    final bool didAuthenticate = await BiometricHelper.authenticate(
        'Please authenticate to setup biometric.');
    if (didAuthenticate) {
      await _biometricViewModel.setupBiometric();
      observeBiometricSetupResponse();
    }
  }

  onPressSetupLater() {
    context.goNamed(AppRoute.landing.name);
  }

  void observeBiometricSetupResponse() {
    if (_biometricViewModel.biometricSetupUseCase.hasCompleted) {
      context.goNamed(AppRoute.landing.name);
    } else {
      showToast(
        context,
        _biometricViewModel.biometricSetupUseCase.exception!,
        isSuccess: false,
      );
    }
  }
}
