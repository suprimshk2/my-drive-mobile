import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/di/di.dart';
import 'package:mydrivenepal/feature/banner/banner_viewmodel.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:mydrivenepal/feature/profile/constants/profile_strings.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/feature/profile/screen/profile_viewmodel.dart';
import 'package:mydrivenepal/feature/profile/widgets/biometric_setting_widget.dart';
import 'package:mydrivenepal/feature/profile/widgets/profile_info_widget.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/info/info_container.dart';
import 'package:mydrivenepal/widget/response_builder.dart';
import 'package:mydrivenepal/widget/shimmer/profile_shimmer.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:provider/provider.dart';
import '../../dashboard/widgets/disclaimer_bottomsheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileViewmodel _profileViewmodel = locator<ProfileViewmodel>();

  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  Future<void> getInitialData() async {
    await _profileViewmodel.getUserData();
    await _profileViewmodel.getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _profileViewmodel,
      child: ScaffoldWidget(
        appbarTitle: ProfileStrings.profile,
        showBackButton: true,
        onPressedIcon: () {
          context.pop();
        },
        padding: Dimens.spacing_8,
        top: Dimens.spacing_large,
        bottom: Dimens.spacing_large,
        bottomBar: _buildBottomBar(context, _profileViewmodel),
        child: Consumer<ProfileViewmodel>(
          builder: (
            context,
            profileViewmodel,
            _,
          ) {
            return ResponseBuilder<UserDataResponse>(
              response: profileViewmodel.userDataUseCase
                  as Response<UserDataResponse>,
              onRetry: () {
                getInitialData();
              },
              onLoading: () => const ProfileShimmer(),
              onData: (UserDataResponse userData) {
                return _buildProfileScreen(
                  context,
                  userData: userData,
                  profileViewmodel: profileViewmodel,
                );
              },
            );
          },
        ),
      ),
    );
  }

  _buildProfileScreen(
    BuildContext context, {
    required UserDataResponse userData,
    required ProfileViewmodel profileViewmodel,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimens.spacing_32),
          _profileItem(context, text: ProfileStrings.profileTitle),
          ProfileInfoWidget(
            icon: Icons.person_outline,
            itemTitle: ProfileStrings.name,
            itemDesc: getFullName(
              firstName: userData.firstName,
              lastName: userData.lastName,
            ),
          ),

          ProfileInfoWidget(
            iconImage: ImageConstants.IC_EMAIL,
            itemTitle: ProfileStrings.email,
            itemDesc: userData.email ?? '',
          ),
          // ProfileInfoWidget(
          //   iconImage: ImageConstants.IC_PHONE,
          //   itemTitle: ProfileStrings.phone,
          //   itemDesc: formatPhoneNumber(userData. ?? ''),
          // ),
          ProfileInfoWidget(
            iconImage: ImageConstants.IC_ROLE,
            itemTitle: ProfileStrings.role,
            itemDesc: 'Member/ Patient',
          ),
          BiometricSettingWidget(),
          SizedBox(height: 25.h),
          _profileItem(context, text: ProfileStrings.legalTitle),
          _getLegatItem(context,
              text: ProfileStrings.terms, url: dotenv.env['TERMS_URL'] ?? ''),
          _getLegatItem(context,
              text: ProfileStrings.privacy,
              url: dotenv.env['POLICY_URL'] ?? ''),
          SizedBox(height: 60.h),
          // _buildBottomBar(context, profileViewmodel),
        ],
      ),
    );
  }

  _profileItem(BuildContext context, {required String text}) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(left: Dimens.spacing_large),
      child: TextWidget(
        text: text,
        style: Theme.of(context)
            .textTheme
            .bodyTextBold
            .copyWith(color: appColors.textInverse),
      ),
    );
  }

  _getLegatItem(BuildContext context,
      {required String text, required String url}) {
    final appColors = context.appColors;

    return InkWell(
      onTap: () => launchExternalUrl(url),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimens.spacing_large),
            child: TextWidget(
              text: text,
              style: Theme.of(context).textTheme.bodyText.copyWith(
                    color: appColors.textPrimary,
                  ),
            ),
          ),
          Divider(height: 1, color: appColors.borderGraySoftAlpha50),
        ],
      ),
    );
  }

  _buildBottomBar(
    BuildContext context,
    ProfileViewmodel profileViewmodel,
  ) {
    final appColors = context.appColors;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacing_large),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => onTappedLogout(context, profileViewmodel),
              child: Container(
                padding: EdgeInsets.only(
                  right: Dimens.spacing_large,
                  top: Dimens.spacing_small,
                  bottom: Dimens.spacing_small,
                ),
                child: Row(
                  children: [
                    TextWidget(
                      text: ProfileStrings.logout,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: appColors.textSubtle),
                    ),
                    SizedBox(width: Dimens.spacing_8),
                    Icon(
                      Icons.logout,
                      size: Dimens.spacing_large,
                    ),
                  ],
                ),
              ),
            ),
            Consumer<ProfileViewmodel>(builder: (context, vm, _) {
              var appVersion = vm.appVersion.data;
              return TextWidget(
                text: _getAppVersion(appVersion),
                style: Theme.of(context)
                    .textTheme
                    .bodyTextSmall
                    .copyWith(color: appColors.textMuted),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getAppVersion(AppVersionModel? appVersion) {
    if (appVersion == null) return '';
    return "${ProfileStrings.version} ${appVersion.version}";
  }

  onTappedLogout(
    BuildContext context,
    ProfileViewmodel viewModel,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<ProfileViewmodel>(
          builder: (context, vm, _) => AlertDialogWidget(
            title: ProfileStrings.logout,
            description: ProfileStrings.logoutDescription,
            firstButtonOnPressed: () => _onTappedLogout(context, vm),
            firstButtonLabel: ProfileStrings.logout,
            firstButtonIsLoading: vm.logoutUseCase.isLoading,
            secondButtonLabel: ProfileStrings.cancel,
            twoButton: true,
          ),
        ),
      ),
    );
  }

  _onTappedLogout(
    BuildContext context,
    ProfileViewmodel viewModel,
  ) async {
    await viewModel.logout();
    if (viewModel.logoutUseCase.data == true) {
      locator<BannerViewModel>().closeBanner(false);
      context.pop();
      context.go(RouteNames.login);
    }
  }
}
