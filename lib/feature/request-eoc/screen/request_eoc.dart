import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydrivenepal/feature/tasks/widgets/radio_options_widget.dart';
import 'package:mydrivenepal/shared/constant/request_eoc_constant.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/shared/util/colors.dart';
import 'package:mydrivenepal/shared/util/dimens.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_filled_button_widget.dart';
import 'package:mydrivenepal/widget/text-field/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../di/service_locator.dart';
import '../../../shared/shared.dart';
import '../../../widget/widget.dart';
import '../../../shared/util/date.dart';
import '../constant/constant.dart';
import '../request_eoc_viewmodel.dart';
import 'select_episode_screen.dart';

class RequestEpisodeOfCareScreen extends StatefulWidget {
  const RequestEpisodeOfCareScreen({super.key});

  @override
  State<RequestEpisodeOfCareScreen> createState() =>
      _RequestEpisodeOfCareScreenState();
}

class _RequestEpisodeOfCareScreenState
    extends State<RequestEpisodeOfCareScreen> {
  final eocViewModel = locator<RequestEpisodeOfCareViewModel>();

  final _formKey = GlobalKey<FormBuilderState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final subscriberIDController = TextEditingController();
  String _selectedContactMethod = ContactType.EMAIL;
  final AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode dobFocusNode = FocusNode();
  final FocusNode subscriberIDFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    eocViewModel.fetchEocList();
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

    return ChangeNotifierProvider(
      create: (BuildContext context) => eocViewModel,
      child: Consumer<RequestEpisodeOfCareViewModel>(
        builder: (context, viewModel, child) => ScaffoldWidget(
          onPressedIcon: () => context.pop(),
          showAppbar: true,
          showBackButton: true,
          appbarTitle: RequestEocConstant.appBarTitle,
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
                    nextNode: subscriberIDFocusNode,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            text: "Subscriber ID",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: appColors.textSubtle),
                          ),
                          const SizedBox(width: Dimens.spacing_4),
                          GestureDetector(
                            onTap: () => _bottomSheetInfo(
                              context,
                              RequestEocConstant.subscriberDetail,
                              RequestEocConstant.subscriberTitle,
                            ),
                            child: ImageWidget(
                              isSvg: true,
                              height: Dimens.text_size_large,
                              width: Dimens.text_size_large,
                              imagePath: ImageConstants.IC_INFO_CIRCLE_FILL,
                              color: appColors.bgPrimaryMain,
                            ),
                          ),
                        ],
                      ),
                      TextWidget(
                        text: "Optional",
                        style: Theme.of(context)
                            .textTheme
                            .bodyTextSmall
                            .copyWith(color: appColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.spacing_8),
                  TextFieldWidget(
                    focusNode: subscriberIDFocusNode,
                    nextNode: phoneFocusNode,
                    textInputAction: TextInputAction.next,
                    name: "subscriberID",
                    hintText: "Subscriber ID",
                    controller: subscriberIDController,
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
                  TextWidget(
                    text: 'How best to contact you?',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: appColors.textSubtle),
                  ),
                  const SizedBox(height: Dimens.spacing_8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioOptionWidget(
                          isSelected:
                              _selectedContactMethod == ContactType.EMAIL,
                          option: ContactType.EMAIL,
                          label: 'Send Email',
                          onOptionSelected: (value) {
                            setState(() {
                              _selectedContactMethod = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: Dimens.spacing_large),
                      Expanded(
                        child: RadioOptionWidget(
                          isSelected:
                              _selectedContactMethod == ContactType.PHONE,
                          option: ContactType.PHONE,
                          label: 'Give a Call',
                          onOptionSelected: (value) {
                            setState(() {
                              _selectedContactMethod = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
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
        ),
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

  observeResponse(
    BuildContext context,
    RequestEpisodeOfCareViewModel viewModel,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (validate()) {
      viewModel.setPersonalInfo(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        dob: (dateOfBirthController.text),
        subscriberId: subscriberIDController.text,
        phone: phoneController.text,
        email: emailController.text,
        contactVia: _selectedContactMethod,
      );
      //TODO: refactor using go router navigation
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: viewModel,
            child: EocSelectScreen(),
          ),
        ),
      );
    }
  }
}

Future<dynamic> _bottomSheetInfo(
    BuildContext context, String message, String title) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight * 0.4),
    builder: (BuildContext context) {
      return Container(
        height: getDeviceHeight(context, value: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_large),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(Dimens.spacing_large),
            topStart: Radius.circular(Dimens.spacing_large),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: Dimens.spacing_extra_large),
                  TextWidget(
                    text: title,
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                  const SizedBox(height: Dimens.spacing_32),
                  Text(message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!),
                  const SizedBox(height: Dimens.spacing_32),
                ],
              ),
            ),
            RoundedFilledButtonWidget(
                context: context,
                label: "Continue",
                onPressed: () {
                  if (!context.mounted) return;
                  context.pop();
                }),
            const SizedBox(height: Dimens.spacing_4),
          ],
        ),
      );
    },
  );
}
