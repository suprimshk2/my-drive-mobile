import 'package:flutter/material.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/auth/screen/biometric/biometric_viewmodel.dart';
import 'package:mydrivenepal/feature/profile/constants/profile_strings.dart';
import 'package:mydrivenepal/feature/profile/widgets/profile_info_widget.dart';
import 'package:mydrivenepal/shared/constant/image_constants.dart';
import 'package:mydrivenepal/shared/helper/biometric_helper.dart';
import 'package:mydrivenepal/shared/util/toast.dart';
import 'package:mydrivenepal/widget/switch/custom_switch.dart';
import 'package:provider/provider.dart';

class BiometricSettingWidget extends StatefulWidget {
  const BiometricSettingWidget({super.key});

  @override
  State<BiometricSettingWidget> createState() => _BiometricSettingWidgetState();
}

class _BiometricSettingWidgetState extends State<BiometricSettingWidget> {
  final BiometricViewModel _biometricViewModel = locator<BiometricViewModel>();

  bool _isBiometricEnable = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    await _biometricViewModel.initBiometricStatus();
    _isBiometricEnable = _biometricViewModel.isBiometricSetup;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BiometricViewModel>(
      create: (context) => _biometricViewModel,
      child: Consumer<BiometricViewModel>(
          builder: (context, biometricViewModel, _) {
        return ProfileInfoWidget(
          iconImage: ImageConstants.IC_FINGERPRINT,
          itemTitle: ProfileStrings.biometric,
          itemContent: Align(
            alignment: Alignment.topLeft,
            child: CustomSwitch(
              value: _isBiometricEnable,
              onChanged: (value) {
                setState(() {
                  _isBiometricEnable = value;
                });

                if (!value) {
                  _disableBiometric();
                } else {
                  _enableBiometric();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  void _disableBiometric() async {
    await _biometricViewModel.disableBiometricLogin();

    if (_biometricViewModel.disableBiometricLoginUseCase.hasCompleted) {
      showToast(context, 'Your biometric has been disabled', isSuccess: true);
    } else {
      setState(() {
        _isBiometricEnable = true;
      });

      showToast(
          context, _biometricViewModel.disableBiometricLoginUseCase.exception!,
          isSuccess: false);
    }
  }

  void _enableBiometric() async {
    final bool didAuthenticate = await BiometricHelper.authenticate(
        'Please authenticate to setup biometric.');
    if (didAuthenticate) {
      await _biometricViewModel.setupBiometric();
      if (_biometricViewModel.biometricSetupUseCase.hasCompleted) {
        showToast(context, 'Your biometric has been enabled',
            isSuccess: true); //TODO: Refactor toast message later
      } else {
        setState(() {
          _isBiometricEnable = false;
        });

        showToast(context, _biometricViewModel.biometricSetupUseCase.exception!,
            isSuccess: false);
      }
    } else {
      setState(() {
        _isBiometricEnable = false;
      });
    }
  }
}
