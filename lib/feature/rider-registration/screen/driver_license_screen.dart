import 'package:flutter/material.dart';
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
      appbarTitle: "Driver licence",
      showBackButton: true,
      child: Consumer<RiderRegistrationViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimens.spacing_large),
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

                  const SizedBox(height: Dimens.spacing_extra_large),

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
      padding: const EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "Driver license number",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: appColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: Dimens.spacing_large),
          TextFieldWidget(
            name: "driverLicenseNumber",
            controller: _driverLicenseController,
            isRequired: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => _updateFormData(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverLicensePhotoSection(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "The front of driver's license",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: appColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: Dimens.spacing_large),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.radius_default),
                child: ImageWidget(
                  imagePath:
                      viewModel.registrationData.driverLicenseFrontPhoto!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ] else ...[
            Container(
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
                      borderRadius: BorderRadius.circular(Dimens.radius_small),
                      border: Border.all(
                        color: appColors.primary.main,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "DRIVER",
                          style: TextStyle(
                            color: appColors.primary.main,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "LICENCE",
                          style: TextStyle(
                            color: appColors.primary.main,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.spacing_12),
                  Text(
                    "NAME",
                    style: TextStyle(
                      color: appColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: Dimens.spacing_large),
          RoundedFilledButtonWidget(
            context: context,
            label: "Add a photo",
            onPressed: () => _handlePhotoUpload('driverLicense'),
            backgroundColor: AppColors.transparent,
            textColor: appColors.primary.main,
            // borderColor: appColors.primary.main,
            // needBorder: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNationalIdSection(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacing_large),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Dimens.radius_default),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "National ID card (front side)",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: appColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: Dimens.spacing_large),
          if (viewModel.registrationData.nationalIdFrontPhoto?.isNotEmpty ==
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.radius_default),
                child: Stack(
                  children: [
                    ImageWidget(
                      imagePath:
                          viewModel.registrationData.nationalIdFrontPhoto!,
                      fit: BoxFit.cover,
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
          ] else ...[
            Container(
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
                      borderRadius: BorderRadius.circular(Dimens.radius_small),
                      border: Border.all(
                        color: appColors.primary.main,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "NATIONAL",
                          style: TextStyle(
                            color: appColors.primary.main,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ID CARD",
                          style: TextStyle(
                            color: appColors.primary.main,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.spacing_12),
                  Text(
                    "NAME",
                    style: TextStyle(
                      color: appColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: Dimens.spacing_large),
          RoundedFilledButtonWidget(
            context: context,
            label: "Add a photo",
            onPressed: () => _handlePhotoUpload('nationalId'),
            backgroundColor: AppColors.transparent,
            textColor: appColors.primary.main,
            // borderColor: appColors.primary.main,
            // needBorder: true,
          ),
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

  Widget _buildDoneButton(BuildContext context,
      RiderRegistrationViewModel viewModel, dynamic appColors) {
    return SizedBox(
      width: double.infinity,
      child: RoundedFilledButtonWidget(
        context: context,
        label: "Done",
        onPressed: viewModel.registrationData.isDriverLicenseComplete
            ? () => _handleDone(context)
            : null,
        enabled: viewModel.registrationData.isDriverLicenseComplete,
        backgroundColor: viewModel.registrationData.isDriverLicenseComplete
            ? null
            : appColors.bgGraySubtle,
        textColor: viewModel.registrationData.isDriverLicenseComplete
            ? AppColors.white
            : appColors.textMuted,
      ),
    );
  }

  void _updateFormData(RiderRegistrationViewModel viewModel) {
    viewModel.updateDriverLicense(
      driverLicenseNumber: _driverLicenseController.text,
    );
  }

  void _handlePhotoUpload(String type) {
    // TODO: Implement photo upload functionality
    // This would typically open image picker and upload to server
    // For now, we'll simulate with a placeholder
    final viewModel = context.read<RiderRegistrationViewModel>();
    if (type == 'driverLicense') {
      viewModel.updateDriverLicense(
        driverLicenseFrontPhoto: 'placeholder_driver_license.jpg',
      );
    } else if (type == 'nationalId') {
      viewModel.updateDriverLicense(
        nationalIdFrontPhoto: 'placeholder_national_id.jpg',
      );
    }
  }

  void _handleDone(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.pop();
    }
  }
}
