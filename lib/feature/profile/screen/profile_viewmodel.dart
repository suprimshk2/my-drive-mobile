import 'package:flutter/material.dart';
import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_role_response.dart';
import 'package:mydrivenepal/feature/profile/data/profile_repository.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_mode_model.dart';
import 'package:mydrivenepal/feature/profile/data/models/permission_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/shared/util/response.dart';
import 'dart:developer';

class ProfileViewmodel extends ChangeNotifier {
  final ProfileRepository _profileRepository;

  ProfileViewmodel({
    required ProfileRepository profileRepository,
  }) : _profileRepository = profileRepository;

  // User Mode Getters - Single source of truth from repository
  UserModeModel? get userMode => _profileRepository.userMode;
  bool get isLoading => _profileRepository.isLoading;
  String? get errorMessage => _profileRepository.errorMessage;
  UserMode get currentMode => _profileRepository.currentMode;
  List<UserMode> get availableModes => _profileRepository.availableModes;
  bool get isDriverMode => _profileRepository.isDriverMode;
  bool get isPassengerMode => _profileRepository.isPassengerMode;
  bool get canSwitchToDriver => _profileRepository.canSwitchToDriver;
  bool get canSwitchToPassenger => _profileRepository.canSwitchToPassenger;
  bool get isModeSwitchEnabled => _profileRepository.isModeSwitchEnabled;

  // // Permission getters - Delegated to repository
  // PermissionManager? get permissionManager =>
  //     _profileRepository.permissionManager;

  // Additional getters - Delegated to repository
  bool get isInitialized => _profileRepository.isInitialized;
  UserDataResponse? get lastUserData => _profileRepository.lastUserData;

  // Profile Data Responses
  Response<AppVersionModel> _appVersion = Response<AppVersionModel>();
  Response<AppVersionModel> get appVersion => _appVersion;

  set appVersion(Response<AppVersionModel> value) {
    _appVersion = value;
    notifyListeners();
  }

  Response<UserDataResponse> _userDataUseCase = Response<UserDataResponse>();
  Response<UserDataResponse> get userDataUseCase => _userDataUseCase;

  set userDataUseCase(Response<UserDataResponse> value) {
    _userDataUseCase = value;
    notifyListeners();
  }

  Response<bool> _logoutUseCase = Response<bool>();
  Response<bool> get logoutUseCase => _logoutUseCase;

  set logoutUseCase(Response<bool> response) {
    _logoutUseCase = response;
    notifyListeners();
  }

  // User Mode Methods with Enhanced Error Handling
  Future<void> initializeUserMode(List<RoleModel>? userRoles) async {
    log("ProfileViewModel: Initializing user mode");
    try {
      await _profileRepository.initializeUserMode(userRoles);
      log("ProfileViewModel: User mode initialized successfully");
      notifyListeners();
    } catch (e) {
      log("ProfileViewModel: Error initializing user mode: $e");
      notifyListeners();
    }
  }

  /// Enhanced switchMode with debugging
  Future<bool> switchMode(UserMode newMode) async {
    log("ProfileViewModel: switchMode called for ${newMode.displayName}");

    // Debug user roles status
    debugUserRoles();

    if (!isModeSwitchEnabled) {
      log("ProfileViewModel: Mode switching is disabled");
      return false;
    }

    if (!availableModes.contains(newMode)) {
      log("ProfileViewModel: Mode ${newMode.displayName} is not available");
      return false;
    }

    final success = await _profileRepository.switchMode(newMode);
    if (success) {
      log("ProfileViewModel: Successfully switched to ${newMode.displayName}");
      notifyListeners();
    } else {
      log("ProfileViewModel: Failed to switch to ${newMode.displayName}");
      log("ProfileViewModel: Error message: ${errorMessage}");
    }
    return success;
  }

  /// Switch mode using role ID directly
  Future<bool> switchModeWithRoleId(String roleId) async {
    log("ProfileViewModel: Switching to role ID: $roleId");

    if (!isModeSwitchEnabled) {
      log("ProfileViewModel: Mode switching is disabled");
      return false;
    }

    final success = await _profileRepository.switchModeWithRoleId(roleId);
    if (success) {
      log("ProfileViewModel: Successfully switched to role ID: $roleId");

      // Refresh user data after successful mode switch
      await _refreshUserDataAfterModeSwitch();

      notifyListeners();
    } else {
      log("ProfileViewModel: Failed to switch to role ID: $roleId");
    }
    return success;
  }

  /// Refresh user data after successful mode switch
  Future<void> _refreshUserDataAfterModeSwitch() async {
    try {
      log("ProfileViewModel: Refreshing user data after mode switch");

      // Fetch updated user data with new token
      await getUserData();

      // Re-initialize user mode with updated data
      final userData = userDataUseCase.data;
      if (userData != null) {
        await initializeFromUserData(userData);
        log("ProfileViewModel: User data refreshed successfully");
      }
    } catch (e) {
      log("ProfileViewModel: Error refreshing user data: $e");
    }
  }

  Future<bool> switchToDriverMode() async {
    return await switchMode(UserMode.rider);
  }

  Future<bool> switchToPassengerMode() async {
    return await switchMode(UserMode.passenger);
  }

  Future<void> loadUserMode() async {
    log("ProfileViewModel: Loading user mode");
    try {
      await _profileRepository.loadUserMode();
      log("ProfileViewModel: User mode loaded successfully");
      notifyListeners();
    } catch (e) {
      log("ProfileViewModel: Error loading user mode: $e");
      notifyListeners();
    }
  }

  Future<void> updateAvailableModes(List<UserMode> newAvailableModes) async {
    log("ProfileViewModel: Updating available modes");
    try {
      await _profileRepository.updateAvailableModes(newAvailableModes);
      log("ProfileViewModel: Available modes updated successfully");
      notifyListeners();
    } catch (e) {
      log("ProfileViewModel: Error updating available modes: $e");
      notifyListeners();
    }
  }

  Future<void> clearUserMode() async {
    log("ProfileViewModel: Clearing user mode");
    try {
      await _profileRepository.clearUserMode();
      log("ProfileViewModel: User mode cleared successfully");
      notifyListeners();
    } catch (e) {
      log("ProfileViewModel: Error clearing user mode: $e");
      notifyListeners();
    }
  }

  void clearError() {
    notifyListeners();
  }

  // Profile Data Methods with User Mode Integration
  Future<void> getVersion() async {
    appVersion = Response.loading();
    try {
      final appVersion = await _profileRepository.getAppVersion();
      this.appVersion = Response.complete(appVersion);
    } catch (error) {
      appVersion = Response.error(error);
    }
  }

  Future<void> getUserData() async {
    userDataUseCase = Response.loading();
    try {
      log("ProfileViewModel: Fetching user data");
      final userData = await _profileRepository.getUserData();
      userDataUseCase = Response.complete(userData);

      // User mode is automatically updated in repository based on user data
      log("ProfileViewModel: User data fetched successfully");
      notifyListeners();
    } catch (error) {
      log("ProfileViewModel: Error fetching user data: $error");
      userDataUseCase = Response.error(error);
    }
  }

  Future<void> logout() async {
    logoutUseCase = Response.loading();
    try {
      log("ProfileViewModel: Logging out user");
      await clearUserMode(); // Clear user mode on logout
      logoutUseCase = Response.complete(true);
      log("ProfileViewModel: Logout successful");
    } catch (e) {
      log("ProfileViewModel: Error during logout: $e");
      logoutUseCase = Response.error(e);
    }
  }

  // Enhanced initialization method that handles user data response
  Future<void> initializeFromUserData(UserDataResponse userData) async {
    log("ProfileViewModel: Initializing from user data");
    try {
      // Convert UserDataResponse roles to RoleModel for consistency
      final roleModels = userData.roles
          ?.map((role) => RoleModel(
                id: int.tryParse(role.id ?? ''),
                roleCode: role.name,
                isActiveRole: true,
                isPrimary: false,
              ))
          .toList();

      await initializeUserMode(roleModels);
      log("ProfileViewModel: Initialized from user data successfully");
    } catch (e) {
      log("ProfileViewModel: Error initializing from user data: $e");
    }
  }

  // UI Helper Methods
  String get currentModeDisplayName => currentMode.displayName;
  String get currentModeIcon => currentMode.iconPath;

  List<UserMode> get switchableModes =>
      availableModes.where((mode) => mode != currentMode).toList();

  // bool canPerformAction(String action) {
  //   switch (action) {
  //     case 'book_ride':
  //       return isPassengerMode && (permissionManager?.canBookTrips ?? false);
  //     case 'accept_ride':
  //       return isDriverMode && (permissionManager?.canAcceptRides ?? false);
  //     case 'view_earnings':
  //       return isDriverMode && (permissionManager?.canViewEarnings ?? false);
  //     case 'view_trips':
  //       return permissionManager?.canViewTrips ?? false;
  //     case 'cancel_trip':
  //       return permissionManager?.canCancelTrips ?? false;
  //     case 'make_payment':
  //       return permissionManager?.canMakePayments ?? false;
  //     case 'manage_profile':
  //       return permissionManager?.canManageProfile ?? false;
  //     default:
  //       return true;
  //   }
  // }

  Response<FetchListResponse<UserRoleResponse>> _userRolesUseCase =
      Response<FetchListResponse<UserRoleResponse>>();
  Response<FetchListResponse<UserRoleResponse>> get userRolesUseCase =>
      _userRolesUseCase;

  set userRolesUseCase(Response<FetchListResponse<UserRoleResponse>> value) {
    _userRolesUseCase = value;
    notifyListeners();
  }

  // User role methods - Optimized with caching
  Future<void> fetchUserRoles() async {
    // Check if we already have cached data
    final cachedRoles = _profileRepository.cachedUserRoles;
    if (cachedRoles != null) {
      log("ProfileViewModel: Using cached user roles");
      userRolesUseCase = Response.complete(cachedRoles);
      return;
    }

    // Check if we're already loading
    if (userRolesUseCase.isLoading) {
      log("ProfileViewModel: Already loading user roles, skipping");
      return;
    }

    userRolesUseCase = Response.loading();
    try {
      log("ProfileViewModel: Fetching user roles");
      final userRoles = await _profileRepository.fetchUserRoles();
      userRolesUseCase = Response.complete(userRoles);
      log("ProfileViewModel: User roles fetched successfully");
    } catch (error) {
      log("ProfileViewModel: Error fetching user roles: $error");
      userRolesUseCase = Response.error(error);
    }
  }

  // Method to clear cached user roles (useful for logout or refresh)
  Future<void> clearCachedUserRoles() async {
    log("ProfileViewModel: Clearing cached user roles");
    await _profileRepository.clearUserRoles();
    userRolesUseCase = Response<FetchListResponse<UserRoleResponse>>();
    notifyListeners();
  }

  // Test methods for development
  Future<void> enableTestModes() async {
    log("ProfileViewModel: Enabling test modes");
    await _profileRepository
        .updateAvailableModes([UserMode.passenger, UserMode.rider]);
    notifyListeners();
  }

  Future<void> resetToPassengerOnly() async {
    log("ProfileViewModel: Resetting to passenger only");
    await _profileRepository.updateAvailableModes([UserMode.passenger]);
    notifyListeners();
  }

  void refreshCurrentMode() {
    log("ProfileViewModel: Refreshing current mode");
    notifyListeners();
  }

  // Validation methods
  bool isModeValid(UserMode mode) {
    return availableModes.contains(mode);
  }

  /// Get role ID for a specific mode
  String? getRoleIdForMode(UserMode mode) {
    final cachedRoles = _profileRepository.cachedUserRoles;
    if (cachedRoles == null) return null;

    for (final role in cachedRoles.rows) {
      if (_doesRoleMatchMode(role, mode)) {
        return role.id;
      }
    }
    return null;
  }

  /// Check if a role matches a mode
  bool _doesRoleMatchMode(dynamic role, UserMode mode) {
    final roleName = role.name.toLowerCase();

    switch (mode) {
      case UserMode.rider:
        return roleName.contains('rider') || roleName.contains('driver');
      case UserMode.passenger:
        return roleName.contains('passenger');
      default:
        return false;
    }
  }

  /// Get all available role IDs for switching
  Map<UserMode, String> getAvailableRoleIds() {
    final result = <UserMode, String>{};
    final cachedRoles = _profileRepository.cachedUserRoles;

    if (cachedRoles == null) return result;

    for (final role in cachedRoles.rows) {
      final mode = _getModeFromRole(role);
      if (availableModes.contains(mode)) {
        result[mode] = role.id;
      }
    }

    return result;
  }

  /// Get mode from role
  UserMode _getModeFromRole(dynamic role) {
    final roleName = role.name.toLowerCase();

    if (roleName.contains('rider') || roleName.contains('driver')) {
      return UserMode.rider;
    } else if (roleName.contains('passenger')) {
      return UserMode.passenger;
    }
    return UserMode.passenger; // default
  }

  /// Debug method to check user roles status
  void debugUserRoles() {
    log("ProfileViewModel: Debug - User roles status:");
    log("ProfileViewModel: hasData: ${userRolesUseCase.hasData}");
    log("ProfileViewModel: isLoading: ${userRolesUseCase.isLoading}");
    log("ProfileViewModel: hasError: ${userRolesUseCase.hasError}");

    if (userRolesUseCase.hasData && userRolesUseCase.data != null) {
      log("ProfileViewModel: User roles count: ${userRolesUseCase.data!.rows.length}");
      for (final role in userRolesUseCase.data!.rows) {
        log("ProfileViewModel: Role - ID: ${role.id}, Name: ${role.name}");
      }
    }

    final cachedRoles = _profileRepository.cachedUserRoles;
    log("ProfileViewModel: Cached roles available: ${cachedRoles != null}");
    if (cachedRoles != null) {
      log("ProfileViewModel: Cached roles count: ${cachedRoles.rows.length}");
    }

    // Show available role IDs
    final availableRoleIds = getAvailableRoleIds();
    log("ProfileViewModel: Available role IDs: $availableRoleIds");
  }

  /// Temporary debug method to test role switching
  Future<void> testRoleSwitching() async {
    log("ProfileViewModel: Testing role switching...");

    // Debug current state
    debugUserRoles();

    // Try to switch to rider mode
    final success = await switchMode(UserMode.rider);
    log("ProfileViewModel: Test switch to rider result: $success");

    if (!success) {
      log("ProfileViewModel: Test failed - Error: ${errorMessage}");
    }
  }
}
