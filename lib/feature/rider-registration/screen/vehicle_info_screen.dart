import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:mydrivenepal/widget/button/button.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import '../viewmodel/rider_registration_viewmodel.dart';

class VehicleInfoScreen extends StatelessWidget {
  const VehicleInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      appbarTitle: "Vehicle Info",
      showBackButton: true,
      child: Consumer<RiderRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(Dimens.spacing_large),
            child: Column(
              children: [
                // Vehicle Info Form
                Container(
                  padding: const EdgeInsets.all(Dimens.spacing_large),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(Dimens.radius_default),
                  ),
                  child: Column(
                    children: [
                      _buildInfoItem(
                        context,
                        "Brand",
                        viewModel.registrationData.vehicleBrand,
                        () => _handleBrandSelection(context, viewModel),
                      ),
                      _buildInfoItem(
                        context,
                        "Picture",
                        viewModel.registrationData.vehiclePhoto,
                        () => _handlePhotoUpload(context, viewModel),
                      ),
                      _buildInfoItem(
                        context,
                        "Registration plate",
                        viewModel.registrationData.registrationPlate,
                        () => _handleRegistrationPlate(context, viewModel),
                      ),
                      _buildInfoItem(
                        context,
                        "Billbook",
                        viewModel.registrationData.billbookPhoto,
                        () => _handleBillbookUpload(context, viewModel),
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
                        ? () => _handleDone(context)
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

                const SizedBox(height: Dimens.spacing_extra_large),

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
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
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
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: appColors.primary.main,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
          horizontal: Dimens.spacing_large,
          vertical: Dimens.spacing_12,
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

  void _handleBrandSelection(
      BuildContext context, RiderRegistrationViewModel viewModel) {
    // TODO: Show brand selection dialog or navigate to brand selection screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Vehicle Brand'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Honda'),
              onTap: () {
                viewModel.updateVehicleInfo(vehicleBrand: 'Honda');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Yamaha'),
              onTap: () {
                viewModel.updateVehicleInfo(vehicleBrand: 'Yamaha');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Suzuki'),
              onTap: () {
                viewModel.updateVehicleInfo(vehicleBrand: 'Suzuki');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bajaj'),
              onTap: () {
                viewModel.updateVehicleInfo(vehicleBrand: 'Bajaj');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handlePhotoUpload(
      BuildContext context, RiderRegistrationViewModel viewModel) {
    // TODO: Implement photo upload functionality
    viewModel.updateVehicleInfo(vehiclePhoto: 'placeholder_vehicle_photo.jpg');
  }

  void _handleRegistrationPlate(
      BuildContext context, RiderRegistrationViewModel viewModel) {
    // TODO: Show registration plate input dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Registration Plate'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'e.g., BA 1 PA 1234',
          ),
          onSubmitted: (value) {
            viewModel.updateVehicleInfo(registrationPlate: value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle save
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleBillbookUpload(
      BuildContext context, RiderRegistrationViewModel viewModel) {
    // TODO: Implement billbook upload functionality
    viewModel.updateVehicleInfo(billbookPhoto: 'placeholder_billbook.jpg');
  }

  void _handleDone(BuildContext context) {
    Navigator.pop(context);
  }
}
