import 'package:go_router/go_router.dart';
import 'package:mydrivenepal/feature/auth/service/google_sign_service.dart';
import 'package:mydrivenepal/feature/profile/constants/profile_strings.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/feature/profile/screen/profile_viewmodel.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_mode_model.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/theme/app_colors_theme_extension.dart';
import 'package:mydrivenepal/shared/theme/app_text_theme.dart';
import 'package:mydrivenepal/widget/alert/alert_dialog_widget.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_filled_button_widget.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_outlined_button_widget.dart';
import 'package:mydrivenepal/widget/image/image.dart';
import 'package:mydrivenepal/widget/shimmer/card_shimmer.dart';
import 'package:mydrivenepal/widget/text/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_isInitializing) return;

    _isInitializing = true;
    try {
      log("SideNavigationBar: Initializing data");

      final profileViewModel = locator<ProfileViewmodel>();

      // Load user data and initialize user mode

      // Initialize user mode from the loaded user data
      final userData = profileViewModel.userDataUseCase.data;
      if (userData != null) {
        await profileViewModel.initializeFromUserData(userData);

        // Fetch user roles for role switching
        log("SideNavigationBar: Fetching user roles...");
        // await profileViewModel.fetchUserRoles();

        // Debug user roles after fetching
        profileViewModel.debugUserRoles();

        log("SideNavigationBar: Data initialized successfully");
      } else {
        log("SideNavigationBar: No user data available");
      }
    } catch (e) {
      log("SideNavigationBar: Error initializing data: $e");
    } finally {
      _isInitializing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: locator<ProfileViewmodel>(),
      child: Consumer<ProfileViewmodel>(
        builder: (context, profileViewModel, child) {
          final userData = profileViewModel.userDataUseCase.data;
          final isLoading = profileViewModel.userDataUseCase.isLoading;
          final appColors = context.appColors;

          // Debug logging
          log("SideNavigationBar: Build - isInitialized: ${profileViewModel.isInitialized}");
          log("SideNavigationBar: Build - currentMode: ${profileViewModel.currentMode}");

          return Drawer(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildUserHeader(context, userData, isLoading, appColors),
                      _buildModeSection(context, profileViewModel),
                      _buildLogoutSection(context, profileViewModel),
                    ],
                  ),
                ),
                !profileViewModel.canSwitchToDriver
                    ? _buildBeADriverSection(context, profileViewModel)
                    : const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSection(
      BuildContext context, ProfileViewmodel profileViewModel) {
    return Column(
      children: [
        if (profileViewModel.isDriverMode) const SizedBox.shrink(),
        Container(
          color: Colors.red,
          height: 100,
        ),
      ],
    );
  }

  Widget _buildUserHeader(
    BuildContext context,
    UserDataResponse? userData,
    bool isLoading,
    dynamic appColors,
  ) {
    return UserAccountsDrawerHeader(
      accountName: isLoading
          ? const CardShimmerWidget(
              height: 10,
              count: 1,
              width: 5,
            )
          : TextWidget(
              style: Theme.of(context).textTheme.bodyText.copyWith(
                    color: appColors.textOnSurface,
                  ),
              text: userData?.displayName ?? 'User'),
      accountEmail: TextWidget(
        text: userData?.email ?? '',
        style: Theme.of(context).textTheme.bodyText.copyWith(
              color: appColors.textOnSurface,
            ),
      ),
      currentAccountPicture: CircleAvatar(
        child: ClipOval(
          child: ImageWidget(
            imagePath: userData?.profilePicture ??
                ImageConstants.IC_TEST_HEADSHOT_IMAGE,
            isSvg: true,
          ),
        ),
      ),
    );
  }

  /// Optimized mode switching with role ID support and enhanced UX
  Future<void> _handleModeSwitchWithRoleId(BuildContext context,
      ProfileViewmodel profileViewModel, UserMode newMode) async {
    try {
      log("SideNavigationBar: Attempting to switch to ${newMode.displayName}");

      // Show loading indicator
      _showLoadingSnackBar(context, 'Switching to ${newMode.displayName}...');

      // Check if user roles are available first
      if (!profileViewModel.userRolesUseCase.hasData) {
        log("SideNavigationBar: No user roles data available, fetching...");
        // await profileViewModel.fetchUserRoles();

        // Check again after fetching
        if (!profileViewModel.userRolesUseCase.hasData) {
          log("SideNavigationBar: Still no user roles after fetching");
          _dismissSnackBar(context);
          _showErrorSnackBar(
              context, 'Unable to load user roles. Please try again.');
          return;
        }
      }

      // Get role ID for the target mode
      final roleId = profileViewModel.getRoleIdForMode(newMode);
      if (roleId == null) {
        log("SideNavigationBar: No role ID found for mode ${newMode.displayName}");
        _dismissSnackBar(context);
        _showErrorSnackBar(context, 'No role found for ${newMode.displayName}');
        return;
      }

      log("SideNavigationBar: Found role ID $roleId for mode ${newMode.displayName}");

      // Switch mode using role ID directly
      final success = await profileViewModel.switchModeWithRoleId(roleId);

      // Dismiss loading indicator
      _dismissSnackBar(context);

      if (success && context.mounted) {
        log("SideNavigationBar: Successfully switched to ${newMode.displayName}");

        // Show success message
        _showSuccessSnackBar(
            context, 'Successfully switched to ${newMode.displayName}');

        // Close drawer
        context.pop();

        // Navigate to appropriate screen based on mode
        _navigateToModeSpecificScreen(context, newMode);
      } else if (context.mounted) {
        log("SideNavigationBar: Failed to switch to ${newMode.displayName}");
        final errorMsg = profileViewModel.errorMessage ?? 'Unknown error';
        log("SideNavigationBar: Error message: $errorMsg");
        _showErrorSnackBar(context, 'Failed to switch mode: $errorMsg');
      }
    } catch (e) {
      log("SideNavigationBar: Error switching mode: $e");
      _dismissSnackBar(context);
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error switching mode: ${e.toString()}');
      }
    }
  }

  /// Navigate to mode-specific screen
  void _navigateToModeSpecificScreen(BuildContext context, UserMode mode) {
    switch (mode) {
      case UserMode.rider:
        // Navigate to driver/rider mode screen
        context.go(RouteNames.userMode);
        break;
      case UserMode.passenger:
        // Navigate to passenger mode screen
        context.go(RouteNames.userMode);
        break;
      default:
        // Default navigation
        context.go(RouteNames.userMode);
    }
  }

  /// Show loading snackbar
  void _showLoadingSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 30), // Long duration for loading
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Dismiss current snackbar
  void _dismissSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Show success snackbar
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildModeSection(
      BuildContext context, ProfileViewmodel profileViewModel) {
    if (!profileViewModel.isModeSwitchEnabled) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Current Mode Display
        _buildCurrentModeDisplay(context, profileViewModel),

        // Mode Switch Buttons with Role ID Support
        if (profileViewModel.switchableModes.isNotEmpty)
          _buildModeSwitchButtons(context, profileViewModel),

        // Loading and Error States
        _buildLoadingAndErrorStates(context, profileViewModel),

        const Divider(),
      ],
    );
  }

  Widget _buildCurrentModeDisplay(
      BuildContext context, ProfileViewmodel profileViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(
            profileViewModel.isDriverMode ? Icons.directions_car : Icons.person,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Mode',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Text(
                  profileViewModel.currentModeDisplayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitchButtons(
      BuildContext context, ProfileViewmodel profileViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: profileViewModel.switchableModes
            .map((mode) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _ModeSwitchButton(
                      mode: mode,
                      isActive: profileViewModel.currentMode == mode,
                      onTap: () => _handleModeSwitchWithRoleId(
                          context, profileViewModel, mode),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLoadingAndErrorStates(
      BuildContext context, ProfileViewmodel profileViewModel) {
    return Column(
      children: [
        // Loading indicator
        if (profileViewModel.isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),

        // Error message
        if (profileViewModel.errorMessage != null)
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
                  Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      profileViewModel.errorMessage!,
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
      ],
    );
  }

  Widget _buildLogoutSection(
      BuildContext context, ProfileViewmodel profileViewModel) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Log out'),
      onTap: () => _onTappedLogout(context, profileViewModel),
    );
  }

  void _onTappedLogout(BuildContext context, ProfileViewmodel viewModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<ProfileViewmodel>(
          builder: (context, vm, _) => AlertDialogWidget(
            title: ProfileStrings.logout,
            description: ProfileStrings.logoutDescription,
            firstButtonOnPressed: () => _performLogout(context, vm),
            firstButtonLabel: ProfileStrings.logout,
            firstButtonIsLoading: vm.logoutUseCase.isLoading,
            secondButtonLabel: ProfileStrings.cancel,
            twoButton: true,
          ),
        ),
      ),
    );
  }

  Future<void> _performLogout(
      BuildContext context, ProfileViewmodel viewModel) async {
    try {
      await viewModel.logout();
      await GoogleSignInService.signOutGoogle();

      if (context.mounted) {
        context.pop();
        context.go(RouteNames.login);
      }
    } catch (e) {
      log("SideNavigationBar: Error during logout: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Builds the "Be a Driver" section at the bottom of the drawer
  Widget _buildBeADriverSection(
      BuildContext context, ProfileViewmodel profileViewModel) {
    // Don't show if user is already in driver mode
    if (profileViewModel.isDriverMode) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _onBeADriverTapped(context, profileViewModel),
              icon: const Icon(Icons.directions_car, color: Colors.white),
              label: const Text(
                'Be a Driver',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: Dimens.spacing_large),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.spacing_12),
                ),
                elevation: 2,
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
          ),

          // Subtitle
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Start earning by driving with us',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Handles the "Be a Driver" button tap with comprehensive logic
  Future<void> _onBeADriverTapped(
      BuildContext context, ProfileViewmodel profileViewModel) async {
    try {
      // Close the drawer first
      if (context.mounted) {
        context.pop();
      }

      // Check if user already has driver capabilities
      if (profileViewModel.canSwitchToDriver) {
        // User can switch to driver mode - show confirmation dialog
        await _showDriverModeConfirmation(context, profileViewModel);
      } else {
        // User needs to register as a driver - navigate to registration
        await _navigateToDriverRegistration(context, profileViewModel);
      }
    } catch (e) {
      log("SideNavigationBar: Error in _onBeADriverTapped: $e");
      if (context.mounted) {
        _showErrorSnackBar(context, 'Something went wrong. Please try again.');
      }
    }
  }

  /// Shows confirmation dialog for switching to driver mode
  Future<void> _showDriverModeConfirmation(
      BuildContext context, ProfileViewmodel profileViewModel) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.directions_car,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('Switch to Driver Mode'),
          ],
        ),
        content: const Text(
          'You already have driver access. Would you like to switch to driver mode now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _switchToDriverMode(context, profileViewModel);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Switch Now'),
          ),
        ],
      ),
    );
  }

  /// Switches the user to driver mode
  Future<void> _switchToDriverMode(
      BuildContext context, ProfileViewmodel profileViewModel) async {
    try {
      // Show loading indicator
      _showLoadingSnackBar(context, 'Switching to Driver Mode...');

      // Attempt to switch to driver mode
      final success = await profileViewModel.switchToDriverMode();

      // Dismiss loading indicator
      _dismissSnackBar(context);

      if (success && context.mounted) {
        // Show success message
        _showSuccessSnackBar(context, 'Successfully switched to Driver Mode!');

        // Navigate to driver mode screen
        context.go(RouteNames.userMode);
      } else if (context.mounted) {
        // Show error message
        final errorMsg =
            profileViewModel.errorMessage ?? 'Failed to switch to driver mode';
        _showErrorSnackBar(context, errorMsg);
      }
    } catch (e) {
      log("SideNavigationBar: Error switching to driver mode: $e");
      _dismissSnackBar(context);
      if (context.mounted) {
        _showErrorSnackBar(
            context, 'Error switching to driver mode: ${e.toString()}');
      }
    }
  }

  /// Navigates to driver registration flow using bottom sheet
  Future<void> _navigateToDriverRegistration(
      BuildContext context, ProfileViewmodel profileViewModel) async {
    try {
      // Show bottom sheet for driver registration
      final shouldProceed = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) =>
            _buildDriverRegistrationBottomSheet(context, profileViewModel),
      );

      if (shouldProceed == true && context.mounted) {
        // Navigate to driver registration screen
        context.go(RouteNames.userMode);

        // Show informational snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Driver registration coming soon!'),
                ),
              ],
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      }
    } catch (e) {
      log("SideNavigationBar: Error navigating to driver registration: $e");
      if (context.mounted) {
        _showErrorSnackBar(
            context, 'Error opening driver registration: ${e.toString()}');
      }
    }
  }

  /// Builds the driver registration bottom sheet
  Widget _buildDriverRegistrationBottomSheet(
      BuildContext context, ProfileViewmodel profileViewModel) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12.0),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Icon(
                              Icons.directions_car,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Become a Driver',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Start earning with MyDriveNepal',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Benefits section
                      Text(
                        'Why Drive with Us?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),

                      _buildBenefitItem(
                        context,
                        Icons.attach_money,
                        'Flexible Earnings',
                        'Earn money on your own schedule',
                      ),
                      _buildBenefitItem(
                        context,
                        Icons.schedule,
                        'Work When You Want',
                        'No fixed hours, drive when convenient',
                      ),
                      _buildBenefitItem(
                        context,
                        Icons.security,
                        'Safe & Secure',
                        'Verified passengers and secure payments',
                      ),
                      _buildBenefitItem(
                        context,
                        Icons.support_agent,
                        '24/7 Support',
                        'Round-the-clock driver support',
                      ),

                      const SizedBox(height: 32),

                      // Requirements section
                      Text(
                        'Requirements',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),

                      _buildRequirementItem(
                        context,
                        'Valid driver\'s license',
                        'Must be at least 21 years old',
                      ),
                      _buildRequirementItem(
                        context,
                        'Clean driving record',
                        'No major violations in the last 3 years',
                      ),
                      _buildRequirementItem(
                        context,
                        'Vehicle inspection',
                        'Your vehicle must meet safety standards',
                      ),
                      _buildRequirementItem(
                        context,
                        'Background check',
                        'Criminal background verification required',
                      ),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: RoundedOutlinedButtonWidget(
                              label: 'Not Now',
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: RoundedFilledButtonWidget(
                                context: context,
                                isLoading: profileViewModel
                                    .assignRoleUseCase.isLoading,
                                label: 'Get Started',
                                onPressed: () async {
                                  await profileViewModel.assignRole();
                                  await profileViewModel.getUserData();
                                  await profileViewModel.switchToDriverMode();
                                  Navigator.of(context).pop(true);
                                  context.push(RouteNames.riderRegistration);
                                }),
                          ),
                        ],
                      ),

                      // Bottom padding for safe area
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  assignRiderRole(ProfileViewmodel profileViewModel) async {}

  /// Builds a benefit item for the bottom sheet
  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a requirement item for the bottom sheet
  Widget _buildRequirementItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              mode == UserMode.rider ? Icons.directions_car : Icons.person,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              mode.displayName,
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
