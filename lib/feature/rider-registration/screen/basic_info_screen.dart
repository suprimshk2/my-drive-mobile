import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:mydrivenepal/widget/button/button.dart';
import 'package:mydrivenepal/widget/scaffold/scaffold_widget.dart';
import 'package:mydrivenepal/widget/text-field/text_field_widget.dart';
import 'package:mydrivenepal/widget/image/image_widget.dart';
import '../viewmodel/rider_registration_viewmodel.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final viewModel = context.read<RiderRegistrationViewModel>();
      // final data = viewModel.registrationData;

      // _firstNameController.text = data.firstName ?? '';
      // _lastNameController.text = data.lastName ?? '';
      // _emailController.text = data.email ?? '';
      // _dateOfBirthController.text = data.dateOfBirth ?? '';
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return ChangeNotifierProvider.value(
      value: context.read<RiderRegistrationViewModel>(),
      child: ScaffoldWidget(
        appbarTitle: "Basic Info",
        showBackButton: true,
        child: Consumer<RiderRegistrationViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(Dimens.spacing_large),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo Section
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _handlePhotoUpload,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: appColors.bgGraySoft,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: appColors.borderGraySoftAlpha50,
                                  width: 2,
                                ),
                              ),
                              child: viewModel.registrationData.profilePhoto
                                          ?.isNotEmpty ==
                                      true
                                  ? ClipOval(
                                      child: ImageWidget(
                                        fit: BoxFit.cover,
                                        imagePath: viewModel
                                            .registrationData.profilePhoto!,
                                      ),
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: appColors.textSubtle,
                                    ),
                            ),
                          ),
                          const SizedBox(height: Dimens.spacing_small),
                          TextWidget(
                            text: "Add profile photo",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: appColors.textSubtle,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimens.spacing_large),

                    // Form Fields
                    TextFieldWidget(
                      controller: _firstNameController,
                      // labelText: "First name",
                      label: "First name",
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(
                      //       errorText: 'First name is required'),
                      // ]),
                      onChanged: (value) => _updateFormData(viewModel),
                      name: 'firstName',
                    ),

                    const SizedBox(height: Dimens.spacing_large),

                    TextFieldWidget(
                      controller: _lastNameController,
                      label: "Last name",
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(
                      //       errorText: 'Last name is required'),
                      // ]),
                      onChanged: (value) => _updateFormData(viewModel),
                      name: '',
                    ),

                    const SizedBox(height: Dimens.spacing_large),

                    TextFieldWidget(
                      controller: _emailController,
                      label: "Email",
                      textInputType: TextInputType.emailAddress,
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(
                      //       errorText: 'Email is required'),
                      //   FormBuilderValidators.email(
                      //       errorText: 'Please enter a valid email'),
                      // ]),
                      onChanged: (value) => _updateFormData(viewModel),
                      name: '',
                    ),

                    const SizedBox(height: Dimens.spacing_large),

                    GestureDetector(
                      onTap: _handleDatePicker,
                      child: AbsorbPointer(
                        child: TextFieldWidget(
                          controller: _dateOfBirthController,
                          label: "Date of birth",
                          suffixIcon: Icons.calendar_today, name: 'dob',

                          // validator: FormBuilderValidators.compose([
                          //   FormBuilderValidators.required(
                          //       errorText: 'Date of birth is required'),
                          // ]),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      child: RoundedFilledButtonWidget(
                        onPressed: () => _handleNext(context),
                        label: "Next",
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateFormData(RiderRegistrationViewModel viewModel) {
    viewModel.updateBasicInfo(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      dateOfBirth: _dateOfBirthController.text,
    );
  }

  void _handlePhotoUpload() {
    // TODO: Implement photo upload functionality
    // This would typically open image picker and upload to server
  }

  void _handleDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate:
          DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
      lastDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
    );

    if (picked != null) {
      _dateOfBirthController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      _updateFormData(context.read<RiderRegistrationViewModel>());
    }
  }

  void _handleNext(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.pop();
    }
  }
}
