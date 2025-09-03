import 'package:flutter/material.dart';
import 'package:mydrivenepal/widget/picker/media/media_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';

import 'package:mydrivenepal/widget/button/button.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';

import 'package:mydrivenepal/widget/image/image_widget.dart';
import '../viewmodel/rider_registration_viewmodel.dart';

class VehiclePhotoScreen extends StatefulWidget {
  const VehiclePhotoScreen({Key? key}) : super(key: key);

  @override
  State<VehiclePhotoScreen> createState() => _VehiclePhotoScreenState();
}

class _VehiclePhotoScreenState extends State<VehiclePhotoScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _driverLicenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _driverLicenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ScaffoldWidget(
      appbarTitle: "Vehicle Photo",
      showBackButton: true,
      child: Consumer<RiderRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            reverse: true,
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: Dimens.spacing_large),

                  // Vehicle Photo  Photo
                  _buildVehiclePhotoSection(context, viewModel, appColors),

                  const SizedBox(height: Dimens.spacing_large),

                  // Done Button
                  _buildDoneButton(context, viewModel, appColors),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehiclePhotoSection(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.registrationData.vehiclePhoto?.isNotEmpty == true) ...[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.radius_default),
                border: Border.all(
                  color: appColors.borderGraySoft,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimens.radius_default),
                      border: Border.all(
                        color: appColors.borderGraySoft,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: Dimens.spacing_100 + Dimens.spacing_50,
                            padding:
                                const EdgeInsets.all(Dimens.spacing_default),
                            child: MediaPickerWidget(
                                enableCamera: true,
                                onImageSelected: (imagePath) {
                                  viewModel.updateVehicleInfo(
                                    vehiclePhoto: imagePath,
                                  );
                                },
                                pickerType: MediaPickerType.vehiclePhoto),
                          );
                        },
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimens.radius_default),
                        child: ImageWidget(
                          imagePath: viewModel.registrationData.vehiclePhoto!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: Dimens.spacing_8,
                    right: Dimens.spacing_8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: appColors.success.main,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            InkWell(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: Dimens.spacing_100 + Dimens.spacing_50,
                    padding: const EdgeInsets.all(Dimens.spacing_default),
                    child: MediaPickerWidget(
                        enableCamera: true,
                        onImageSelected: (imagePath) {
                          viewModel.updateVehicleInfo(
                            vehiclePhoto: imagePath,
                          );
                        },
                        pickerType: MediaPickerType.vehiclePhoto),
                  );
                },
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: appColors.bgGraySubtle,
                  borderRadius: BorderRadius.circular(Dimens.radius_default),
                  border: Border.all(
                    color: appColors.borderGraySoft,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(Dimens.radius_small),
                        border: Border.all(
                          color: appColors.primary.subtle,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "VEHICLE",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: appColors.primary.subtle,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "PHOTO",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: appColors.primary.subtle,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  Widget _buildDoneButton(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return SizedBox(
      width: double.infinity,
      child: RoundedFilledButtonWidget(
        context: context,
        label: "Done",
        onPressed: () => _handleDone(context, viewModel),
        // enabled: viewModel.registrationData.isDriverLicenseComplete,
        // backgroundColor: viewModel.registrationData.isDriverLicenseComplete
        //     ? null
        //     : appColors.bgGraySubtle,
      ),
    );
  }

  void _handleDone(BuildContext context, RiderRegistrationViewModel viewModel) {
    if (viewModel.registrationData.vehiclePhoto?.isNotEmpty == true) {
      viewModel.updateVehicleInfo(
        vehiclePhoto: viewModel.registrationData.vehiclePhoto,
      );
      context.pop();
    }
  }
}
