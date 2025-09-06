import 'package:flutter/material.dart';
import 'package:mydrivenepal/widget/picker/media/media_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:mydrivenepal/widget/button/button.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import 'package:mydrivenepal/widget/text-field/text_field_widget.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import '../viewmodel/rider_registration_viewmodel.dart';

class DriverLicenseScreen extends StatefulWidget {
  const DriverLicenseScreen({Key? key}) : super(key: key);

  @override
  State<DriverLicenseScreen> createState() => _DriverLicenseScreenState();
}

class _DriverLicenseScreenState extends State<DriverLicenseScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _driverLicenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<RiderRegistrationViewModel>();
      _driverLicenseController.text =
          viewModel.registrationData.driverLicenseNumber ?? '';
    });
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
      appbarTitle: "Driver license",
      showBackButton: true,
      child: Consumer<RiderRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            reverse: true,
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  // Driver License Number
                  _buildDriverLicenseNumberSection(
                      context, viewModel, appColors),

                  const SizedBox(height: Dimens.spacing_large),

                  // Driver License Front Photo
                  _buildDriverLicensePhotoSection(
                      context, viewModel, appColors),

                  const SizedBox(height: Dimens.spacing_large),

                  // National ID Card Photo
                  _buildNationalIdSection(context, viewModel, appColors),

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

  Widget _buildDriverLicenseNumberSection(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldWidget(
            textInputAction: TextInputAction.next,
            name: "driverLicenseNumber",
            hintText: "Driver license number",
            controller: _driverLicenseController,
            isRequired: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          TextWidget(
            text: "${_driverLicenseController.text}",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: appColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverLicensePhotoSection(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.registrationData.driverLicenseFrontPhoto?.isNotEmpty ==
              true) ...[
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
                                  viewModel.updateDriverLicense(
                                    driverLicenseFrontPhoto: imagePath,
                                  );
                                },
                                pickerType: MediaPickerType.licensePhoto),
                          );
                        },
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Dimens.radius_default),
                        child: ImageWidget(
                          imagePath: viewModel
                              .registrationData.driverLicenseFrontPhoto!,
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
                          viewModel.updateDriverLicense(
                            driverLicenseFrontPhoto: imagePath,
                          );
                        },
                        pickerType: MediaPickerType.licensePhoto),
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
                            "DRIVER",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: appColors.primary.subtle,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "LICENCE",
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

  Widget _buildNationalIdSection(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.registrationData.nationalIdFrontPhoto?.isNotEmpty ==
              true) ...[
            InkWell(
              onTap: () => showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: Dimens.spacing_100 + Dimens.spacing_50,
                    padding: const EdgeInsets.all(Dimens.spacing_default),
                    child: MediaPickerWidget(
                        onImageSelected: (imagePath) {
                          viewModel.updateDriverLicense(
                            nationalIdFrontPhoto: imagePath,
                          );
                        },
                        // onImageUploaded: (imagePath) {
                        //   viewModel.u(
                        //     nationalIdFrontPhoto: imagePath,
                        //   );
                        // },
                        enableCamera: true,
                        pickerType: MediaPickerType.nationalIdPhoto),
                  );
                },
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: appColors.primary.subtle,
                  borderRadius: BorderRadius.circular(Dimens.radius_default),
                  border: Border.all(
                    color: appColors.borderGraySoft,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.radius_default),
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
                        child: ImageWidget(
                          imagePath:
                              viewModel.registrationData.nationalIdFrontPhoto!,
                          fit: BoxFit.cover,
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
                        onImageSelected: (imagePath) {
                          viewModel.updateDriverLicense(
                            nationalIdFrontPhoto: imagePath,
                          );
                        },
                        // onImageUploaded: (imagePath) {
                        //   viewModel.u(
                        //     nationalIdFrontPhoto: imagePath,
                        //   );
                        // },
                        enableCamera: true,
                        pickerType: MediaPickerType.nationalIdPhoto),
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
                            "NATIONAL",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: appColors.primary.subtle,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            "ID CARD",
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
          const SizedBox(height: Dimens.spacing_large),
          TextWidget(
            text:
                "Upload front side of citizenship ID/national id card/voter ID / कृपया नागरिकता/राष्ट्रिय परिचयपत्र/मतदाता परिचयपत्रको अगाडिको भाग अपलोड गर्नुहोस्",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: appColors.textSubtle,
                ),
            textAlign: TextAlign.center,
          ),
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
    if (validate()) {
      viewModel.updateDriverLicense(
        driverLicenseNumber: _driverLicenseController.text,
        driverLicenseFrontPhoto:
            viewModel.registrationData.driverLicenseFrontPhoto,
        driverLicense: viewModel.registrationData.driverLicenseFrontPhoto,
      );
      context.pop();
    }
  }
}
