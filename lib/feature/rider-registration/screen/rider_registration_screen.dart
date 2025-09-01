import 'package:flutter/material.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:mydrivenepal/widget/button/button.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import '../viewmodel/rider_registration_viewmodel.dart';
import '../widget/registration_step_item.dart';

class RiderRegistrationScreen extends StatefulWidget {
  const RiderRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RiderRegistrationScreen> createState() =>
      _RiderRegistrationScreenState();
}

class _RiderRegistrationScreenState extends State<RiderRegistrationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // viewModel.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      appbarTitle: "Registration",
      // showCloseButton: true,
      child: Consumer<RiderRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(Dimens.spacing_large),
            child: Column(
              children: [
                // Registration Steps
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.radius_default),
                  ),
                  child: Column(
                    children: [
                      RegistrationStepItem(
                        title: "Basic info",
                        onTap: () =>
                            context.pushNamed(AppRoute.riderBasicInfo.name),
                        isCompleted:
                            viewModel.registrationData.isBasicInfoComplete,
                        isActive:
                            !viewModel.registrationData.isBasicInfoComplete,
                      ),
                      RegistrationStepItem(
                        title: "Driver licence",
                        onTap: () =>
                            context.pushNamed(AppRoute.riderDriverLicense.name),
                        isCompleted:
                            viewModel.registrationData.isDriverLicenseComplete,
                        isActive: viewModel
                                .registrationData.isBasicInfoComplete &&
                            !viewModel.registrationData.isDriverLicenseComplete,
                      ),
                      RegistrationStepItem(
                        title: "Selfie with ID",
                        onTap: () =>
                            context.pushNamed(AppRoute.riderDriverLicense.name),
                        isCompleted: viewModel.registrationData
                                .nationalIdFrontPhoto?.isNotEmpty ==
                            true,
                        isActive: viewModel
                                .registrationData.isDriverLicenseComplete &&
                            viewModel.registrationData.nationalIdFrontPhoto
                                    ?.isEmpty ==
                                true,
                      ),
                      RegistrationStepItem(
                        title: "Vehicle Info",
                        onTap: () =>
                            context.pushNamed(AppRoute.riderVehicleInfo.name),
                        isCompleted:
                            viewModel.registrationData.isVehicleInfoComplete,
                        isActive: viewModel
                                .registrationData.isDriverLicenseComplete &&
                            !viewModel.registrationData.isVehicleInfoComplete,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Dimens.spacing_extra_large),

                // Done Button
                SizedBox(
                  width: double.infinity,
                  child: RoundedFilledButtonWidget(
                    context: context,
                    label: "Done",
                    onPressed: viewModel.registrationData.isRegistrationComplete
                        ? () => _handleSubmit(context, viewModel)
                        : null,
                    enabled: viewModel.registrationData.isRegistrationComplete,
                    backgroundColor:
                        viewModel.registrationData.isRegistrationComplete
                            ? null
                            : appColors.bgGraySubtle,
                    textColor: viewModel.registrationData.isRegistrationComplete
                        ? AppColors.white
                        : appColors.textMuted,
                  ),
                ),

                const SizedBox(height: Dimens.spacing_extra_large),

                // Terms and Conditions
                TextWidget(
                  text: 'By tapping «Submit» you agree with our ',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: appColors.textSubtle,
                      ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to Terms and Conditions
                      },
                      child: TextWidget(
                        text: 'Terms and Conditions',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: appColors.primary.main,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                    TextWidget(
                      text: ' and ',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: appColors.textSubtle,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to Privacy Policy
                      },
                      child: TextWidget(
                        text: 'Privacy Policy',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: appColors.primary.main,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToBasicInfo(BuildContext context) {
    context.pushNamed(AppRoute.riderBasicInfo.name);
  }

  void _navigateToDriverLicense(BuildContext context) {
    context.pushNamed(AppRoute.riderDriverLicense.name);
  }

  void _navigateToVehicleInfo(BuildContext context) {
    context.pushNamed(AppRoute.riderVehicleInfo.name);
  }

  void _handleSubmit(
      BuildContext context, RiderRegistrationViewModel viewModel) async {
    final success = await viewModel.submitRegistration();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Registration submitted successfully! You can now switch to rider mode.'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }
}
