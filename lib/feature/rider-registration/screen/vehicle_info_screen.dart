import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/rider-registration/widget/registration_step_item.dart';
import 'package:mydrivenepal/widget/dropdown/drop_down_menu_widget.dart';
import 'package:mydrivenepal/widget/text-field/text_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:mydrivenepal/widget/button/button.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import '../viewmodel/rider_registration_viewmodel.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final _brandController = TextEditingController();
  final _registrationPlateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<RiderRegistrationViewModel>();
      _brandController.text = viewModel.registrationData.vehicleBrand ?? '';
      _registrationPlateController.text =
          viewModel.registrationData.registrationPlate ?? '';
    });
  }

  @override
  void dispose() {
    _brandController.dispose();
    _registrationPlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    List<DropdownMenuItem<String>> dropDownMenuItems =
        ["Car", "Motorcycle", "Scooter"].map((String item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item),
      );
    }).toList();
    return ScaffoldWidget(
      appbarTitle: "Vehicle Info",
      showBackButton: true,
      child: Consumer<RiderRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Vehicle Info Form
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.radius_default),
                ),
                child: Column(
                  children: [
                    RegistrationStepItem(
                      title: "Brand",
                      onTap: () => _handleBrandSelection(
                          context, viewModel, _brandController),
                      isCompleted:
                          viewModel.registrationData.vehicleBrand?.isNotEmpty ==
                              true,
                      isActive:
                          viewModel.registrationData.vehicleBrand?.isEmpty ==
                              true,
                    ),
                    RegistrationStepItem(
                      title: "Picture",
                      onTap: () => _handlePhotoUpload(context, viewModel),
                      isCompleted:
                          viewModel.registrationData.vehiclePhoto?.isNotEmpty ==
                              true,
                      isActive:
                          viewModel.registrationData.vehiclePhoto?.isEmpty ==
                              true,
                    ),
                    RegistrationStepItem(
                      title: "Registration plate",
                      onTap: () => _handleRegistrationPlate(
                          context, viewModel, _registrationPlateController),
                      isCompleted: viewModel
                              .registrationData.registrationPlate?.isNotEmpty ==
                          true,
                      isActive: viewModel
                              .registrationData.registrationPlate?.isEmpty ==
                          true,
                    ),
                    RegistrationStepItem(
                      title: "Billbook",
                      onTap: () =>
                          context.pushNamed(AppRoute.riderVehicleDoc.name),
                      isCompleted:
                          viewModel.registrationData.vehicleProductionYear
                                      ?.isNotEmpty ==
                                  true ||
                              viewModel.registrationData.vehicleProductionYear
                                      ?.isNotEmpty ==
                                  true ||
                              viewModel
                                      .registrationData
                                      .vehicleRegistrationNumberPhoto
                                      ?.isNotEmpty ==
                                  true ||
                              viewModel
                                      .registrationData
                                      .vehicleRegistrationDetailsPhoto
                                      ?.isNotEmpty ==
                                  true,
                      isActive:
                          viewModel.registrationData.vehicleProductionYear
                                      ?.isEmpty ==
                                  true ||
                              viewModel
                                      .registrationData
                                      .vehicleRegistrationNumberPhoto
                                      ?.isEmpty ==
                                  true ||
                              viewModel
                                      .registrationData
                                      .vehicleRegistrationDetailsPhoto
                                      ?.isEmpty ==
                                  true,
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
                  onPressed: viewModel.registrationData.isVehicleInfoComplete
                      ? () => _handleVehicleDone(
                          context, viewModel, _brandController)
                      : null,
                  enabled: viewModel.registrationData.isVehicleInfoComplete,
                  backgroundColor:
                      viewModel.registrationData.isVehicleInfoComplete
                          ? null
                          : appColors.bgGraySubtle,
                  textColor: viewModel.registrationData.isVehicleInfoComplete
                      ? AppColors.white
                      : appColors.textMuted,
                ),
              ),

              Spacer(),

              // Support Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimens.spacing_large),
                decoration: BoxDecoration(
                  color: appColors.warning.subtle,
                  borderRadius: BorderRadius.circular(Dimens.radius_default),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: appColors.warning.main,
                      size: 20,
                    ),
                    const SizedBox(width: Dimens.spacing_12),
                    Expanded(
                      child: TextWidget(
                        text: "If you have questions, please contact ",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: appColors.textSubtle,
                            ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to support
                      },
                      child: TextWidget(
                        text: "Support",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: appColors.primary.main,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String title,
    String? value,
    VoidCallback onTap,
  ) {
    final appColors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appColors.borderGraySoftAlpha50,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: Dimens.spacing_2,
        ),
        title: TextWidget(
          text: title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: appColors.textInverse,
              ),
        ),
        subtitle: value?.isNotEmpty == true
            ? TextWidget(
                text: value!,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: appColors.textSubtle,
                    ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: appColors.textMuted,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  void _handleBrandDone(
      BuildContext context,
      RiderRegistrationViewModel viewModel,
      TextEditingController brandController) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (brandController.text.isNotEmpty) {
      viewModel.updateVehicleInfo(
        vehicleBrand: brandController.text,
      );
      context.pop();
    }
  }

  void _handleBrandSelection(
      BuildContext context,
      RiderRegistrationViewModel viewModel,
      TextEditingController brandController) {
    String? type = viewModel.registrationData.vehicleType;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        height: isKeyboardVisible(context)
            ? 900
            : Dimens.spacing_300 + Dimens.spacing_50,
        padding: const EdgeInsets.all(Dimens.spacing_default),
        child: Column(
          children: [
            SizedBox(height: Dimens.spacing_over_large),
            TextFieldWidget(
              onFieldSubmitted: (_) =>
                  _handleBrandDone(context, viewModel, brandController),
              textInputAction: TextInputAction.done,
              name: "brand",
              hintText: "Brand",
              controller: brandController,
              isRequired: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: Dimens.spacing_default),
            DropDownMenuWidget(
              name: "type",
              label: "",
              hint: "Select Vehicle Type",
              value: type,
              items: viewModel.vehicleTypeDropdownItems, // Use viewModel method
              onChanged: (value) {
                viewModel.updateVehicleType(value); // Use viewModel method
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: RoundedFilledButtonWidget(
                context: context,
                label: "Done",
                onPressed: () =>
                    _handleBrandDone(context, viewModel, brandController),
                // enabled: viewModel.registrationData.isDriverLicenseComplete,
                // backgroundColor: viewModel.registrationData.isDriverLicenseComplete
                //     ? null
                //     : appColors.bgGraySubtle,
              ),
            ),
            SizedBox(height: Dimens.spacing_32),
          ],
        ),
      ),
    );
  }

  void _handlePhotoUpload(
      BuildContext context, RiderRegistrationViewModel viewModel) {
    context.pushNamed(AppRoute.riderVehiclePhoto.name);
    // viewModel.updateVehicleInfo(vehiclePhoto: 'placeholder_vehicle_photo.jpg');
  }

  void _handleRegistrationPlate(
      BuildContext context,
      RiderRegistrationViewModel viewModel,
      TextEditingController registrationPlateController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: isKeyboardVisible(context)
            ? 500
            : Dimens.spacing_100 + Dimens.spacing_50,
        padding: const EdgeInsets.all(Dimens.spacing_default),
        child: Column(
          children: [
            TextFieldWidget(
              onFieldSubmitted: (_) => _handleRegisterationDone(
                  context, viewModel, registrationPlateController),
              textInputAction: TextInputAction.done,
              name: "registrationPlate",
              hintText: "Registration Plate Number",
              controller: registrationPlateController,
              isRequired: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: RoundedFilledButtonWidget(
                context: context,
                label: "Done",
                onPressed: () => _handleRegisterationDone(
                    context, viewModel, registrationPlateController),
                // enabled: viewModel.registrationData.isDriverLicenseComplete,
                // backgroundColor: viewModel.registrationData.isDriverLicenseComplete
                //     ? null
                //     : appColors.bgGraySubtle,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleRegisterationDone(
      BuildContext context,
      RiderRegistrationViewModel viewModel,
      TextEditingController registrationPlateController) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (registrationPlateController.text.isNotEmpty) {
      viewModel.updateVehicleInfo(
        registrationPlate: registrationPlateController.text,
      );
      context.pop();
    }
  }

  void _handleVehicleDone(
      BuildContext context,
      RiderRegistrationViewModel viewModel,
      TextEditingController brandController) {
    FocusManager.instance.primaryFocus?.unfocus();

    if (brandController.text.isNotEmpty) {
      viewModel.updateDriverLicense(
        driverLicenseNumber: brandController.text,
        driverLicenseFrontPhoto:
            viewModel.registrationData.driverLicenseFrontPhoto,
        nationalIdFrontPhoto: viewModel.registrationData.nationalIdFrontPhoto,
      );
      context.pop();
    }
  }
}
