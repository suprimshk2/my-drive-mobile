import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/auth/service/google_sign_service.dart';
import 'package:mydrivenepal/feature/profile/constants/profile_strings.dart';
import 'package:mydrivenepal/feature/profile/screen/profile_viewmodel.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/alert/alert_dialog_widget.dart';
import 'package:mydrivenepal/widget/image/image.dart';
import 'package:mydrivenepal/widget/shimmer/card_shimmer.dart';
import 'package:mydrivenepal/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode.dart';
import 'package:mydrivenepal/di/service_locator.dart';

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  bool switchValue = true;
  final ProfileViewmodel _profileViewModel = locator<ProfileViewmodel>();
  @override
  void initState() {
    super.initState();
    _profileViewModel.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _profileViewModel,
        child: Consumer<ProfileViewmodel>(
          builder: (context, profileViewModel, child) {
            final userData = profileViewModel.userDataUseCase.data;
            final isLoading = profileViewModel.userDataUseCase.isLoading;
            final appColors = context.appColors;
            print("userData-->${userData?.toJson()}");
            return Consumer<UserModeViewModel>(
              builder: (context, userModeViewModel, child) {
                return Drawer(
                  child: ListView(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: isLoading
                            ? const CardShimmerWidget(
                                height: 10,
                                count: 1,
                                width: 5,
                              )
                            : TextWidget(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText
                                    .copyWith(
                                      color: appColors.textOnSurface,
                                    ),
                                text:
                                    '${userData?.firstName ?? ''} ${userData?.lastName ?? ''}'),
                        accountEmail: TextWidget(
                          text: userData?.email ?? '',
                          style: Theme.of(context).textTheme.bodyText.copyWith(
                                color: appColors.textOnSurface,
                              ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          child: ClipOval(
                            child: ImageWidget(
                              imagePath: userData?.providerData?.profileUrl ??
                                  ImageConstants.IC_TEST_HEADSHOT_IMAGE,
                              isSvg: true,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // User Mode Toggle Section
                          if (userModeViewModel.isModeSwitchEnabled) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    userModeViewModel.isDriverMode
                                        ? Icons.directions_car
                                        : Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Current Mode',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                        Text(
                                          userModeViewModel
                                              .currentMode.displayName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Mode Switch Buttons
                            if (userModeViewModel.canSwitchToDriver &&
                                userModeViewModel.canSwitchToPassenger)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _ModeSwitchButton(
                                        mode: UserMode.passenger,
                                        isActive:
                                            userModeViewModel.isPassengerMode,
                                        onTap: () => _handleModeSwitch(
                                            context,
                                            userModeViewModel,
                                            UserMode.passenger),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _ModeSwitchButton(
                                        mode: UserMode.driver,
                                        isActive:
                                            userModeViewModel.isDriverMode,
                                        onTap: () => _handleModeSwitch(context,
                                            userModeViewModel, UserMode.driver),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Loading indicator
                            if (userModeViewModel.isLoading)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),

                            // Error message
                            if (userModeViewModel.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.red[600], size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          userModeViewModel.errorMessage!,
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            const Divider(),
                          ],

                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Log out'),
                            onTap: () =>
                                onTappedLogout(context, profileViewModel),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ));
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
}

_onTappedLogout(
  BuildContext context,
  ProfileViewmodel viewModel,
) async {
  await viewModel.logout();
  GoogleSignInService.signOutGoogle();

  // if (viewModel.logoutUseCase.data == true) {
  context.pop();
  context.go(RouteNames.login);

  // }
}

Future<void> _handleModeSwitch(BuildContext context,
    UserModeViewModel userModeViewModel, UserMode newMode) async {
  bool success;
  if (newMode == UserMode.passenger) {
    success = await userModeViewModel.switchToPassengerMode();
  } else {
    success = await userModeViewModel.switchToDriverMode();
  }

  if (success) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${newMode.displayName}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Close drawer
    context.pop();
    context.go(RouteNames.userMode);
  } else {
    // Error is already handled in the ViewModel and displayed in the UI
  }
}

class _ModeSwitchButton extends StatelessWidget {
  final UserMode mode;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeSwitchButton({
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color:
                isActive ? Theme.of(context).primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mode == UserMode.driver ? Icons.directions_car : Icons.person,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mode == UserMode.driver ? 'Driver' : 'Passenger',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
