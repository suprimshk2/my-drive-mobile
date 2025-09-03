import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
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

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  final AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode dobFocusNode = FocusNode();

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
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  handleDatePicker() async {
    DateTime? date = await openDatePicker(
      context,
    );
    if (date != null) {
      dateOfBirthController.text = formatRegisterDate(date.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Consumer<RiderRegistrationViewModel>(
        builder: (context, viewModel, child) => ScaffoldWidget(
              onPressedIcon: () => context.pop(),
              showAppbar: true,
              showBackButton: true,
              appbarTitle: 'Basic Info',
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Name',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: appColors.textSubtle),
                      ),
                      const SizedBox(height: Dimens.spacing_8),
                      TextFieldWidget(
                        textInputAction: TextInputAction.next,
                        focusNode: firstNameFocusNode,
                        nextNode: lastNameFocusNode,
                        name: "firstName",
                        hintText: "First Name",
                        controller: firstNameController,
                        isRequired: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: Dimens.spacing_8),
                      TextFieldWidget(
                        textInputAction: TextInputAction.next,
                        focusNode: lastNameFocusNode,
                        nextNode: dobFocusNode,
                        name: "lastName",
                        hintText: "Last Name",
                        controller: lastNameController,
                        isRequired: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: Dimens.spacing_large),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: "Date of Birth",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: appColors.textSubtle),
                          ),
                          TextWidget(
                            text: "MM/DD/YY",
                            style: Theme.of(context)
                                .textTheme
                                .bodyTextSmall
                                .copyWith(color: appColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimens.spacing_8),
                      TextFieldWidget(
                        focusNode: dobFocusNode,
                        nextNode: phoneFocusNode,
                        textInputAction: TextInputAction.next,
                        onTap: handleDatePicker,
                        borderColor: appColors.gray.soft,
                        hintText: "--/--/--",
                        name: "dateOfBirth",
                        controller: dateOfBirthController,
                        isRequired: true,
                        autoFocus: false,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: Dimens.spacing_large),
                      TextWidget(
                        text: 'Contact Information',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: appColors.textSubtle),
                      ),
                      const SizedBox(height: Dimens.spacing_8),
                      TextFieldWidget(
                        inputFormat: [TextFieldMaskings.phoneNumberMasking],
                        textInputAction: TextInputAction.next,
                        focusNode: phoneFocusNode,
                        nextNode: emailFocusNode,
                        name: "phone",
                        hintText: "Phone Number",
                        controller: phoneController,
                        isRequired: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: [
                          FormBuilderValidators.minLength(
                            14,
                            errorText: "Invalid phone number",
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimens.spacing_8),
                      TextFieldWidget(
                        textInputAction: TextInputAction.next,
                        focusNode: emailFocusNode,
                        name: "email",
                        hintText: "Email",
                        controller: emailController,
                        isRequired: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: [
                          FormBuilderValidators.email(
                            errorText: "Invalid email address",
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimens.spacing_large),
                      SizedBox(height: 100.h),
                      RoundedFilledButtonWidget(
                        context: context,
                        label: "Continue",
                        onPressed: () => observeResponse(context, viewModel),
                      ),
                      const SizedBox(height: Dimens.spacing_large),
                    ],
                  ),
                ),
              ),
            ));
  }

  bool validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  observeResponse(
    BuildContext context,
    RiderRegistrationViewModel viewModel,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (validate()) {
      viewModel.updateBasicInfo(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        dateOfBirth: dateOfBirthController.text,
        email: emailController.text,
      );
      // viewModel.setPersonalInfo(
      //   firstName: firstNameController.text,
      //   lastName: lastNameController.text,
      //   dob: (dateOfBirthController.text),
      //   subscriberId: subscriberIDController.text,
      //   phone: phoneController.text,
      //   email: emailController.text,
      //   contactVia: _selectedContactMethod,
      // );
      //TODO: refactor using go router navigation
      context.pop();
    }
  }
}

  // void _updateFormData(RiderRegistrationViewModel viewModel) {
  //   viewModel.updateBasicInfo(
  //     firstName:  firstNameController.text,
  //     lastName: lastNameController.text,
  //     email: emailController.text,
  //     dateOfBirth: dateOfBirthController.text,
  //   );
  // }

  // void _handlePhotoUpload() {
  //   // TODO: Implement photo upload functionality
  //   // This would typically open image picker and upload to server
  // }

  // void _handleDatePicker() async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate:
  //         DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
  //     firstDate:
  //         DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
  //     lastDate:
  //         DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
  //   );

  //   if (picked != null) {
  //     _dateOfBirthController.text =
  //         "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
  //     _updateFormData(context.read<RiderRegistrationViewModel>());
  //   }
  // }

  // void _handleNext(BuildContext context) {
  //   if (_formKey.currentState!.validate()) {
  //     context.pop();
  //   }
  // }

