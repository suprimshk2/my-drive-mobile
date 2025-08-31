import 'dart:developer';
import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';
import 'package:mydrivenepal/feature/profile/data/models/switch_user_mode_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_mode_model.dart';
import 'package:mydrivenepal/feature/profile/data/models/permission_model.dart';
import 'package:mydrivenepal/feature/profile/data/local/profile_local.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_role_response.dart';
import 'package:mydrivenepal/feature/profile/data/remote/profile_remote.dart';
import 'package:mydrivenepal/feature/auth/auth.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/constant/route_names.dart';
import 'package:mydrivenepal/navigation/navigation_routes.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocal _profileLocal;
  final ProfileRemote _profileRemote;
  final AuthLocal _authLocal;

  ProfileRepositoryImpl({
    required ProfileLocal profileLocal,
    required ProfileRemote profileRemote,
    required AuthLocal authLocal,
  })  : _profileLocal = profileLocal,
        _profileRemote = profileRemote,
        _authLocal = authLocal;

  // User Mode State
  UserModeModel? _userMode;
  bool _isLoading = false;
  String? _errorMessage;
  UserDataResponse? _lastUserData;
  bool _isInitialized = false;

  // Cached user roles
  FetchListResponse<UserRoleResponse>? _cachedUserRoles;

  // User Mode Getters
  @override
  UserModeModel? get userMode => _userMode;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  UserMode get currentMode => _userMode?.currentMode ?? UserMode.passenger;

  @override
  List<UserMode> get availableModes =>
      _userMode?.availableModes ?? [UserMode.passenger, UserMode.rider];

  @override
  bool get isDriverMode => currentMode == UserMode.rider;

  @override
  bool get isPassengerMode => currentMode == UserMode.passenger;

  @override
  bool get canSwitchToDriver => _userMode?.canSwitchToDriver ?? false;

  @override
  bool get canSwitchToPassenger => _userMode?.canSwitchToPassenger ?? true;

  @override
  bool get isModeSwitchEnabled => _userMode?.isModeSwitchEnabled ?? true;

  // Additional getters for better state management
  bool get isInitialized => _isInitialized;
  UserDataResponse? get lastUserData => _lastUserData;

  // Cached user roles getter
  @override
  FetchListResponse<UserRoleResponse>? get cachedUserRoles => _cachedUserRoles;

  // Enhanced User Mode Methods with Response Integration
  @override
  Future<void> initializeUserMode(List<RoleModel>? userRoles) async {
    if (_isLoading) {
      log("ProfileRepository: Already loading, skipping initialization");
      return;
    }

    _setLoading(true);
    try {
      log("ProfileRepository: Initializing user mode with ${userRoles?.length ?? 0} roles");

      // Parse roles and determine available modes
      final availableModes = _parseAvailableModesFromRoles(userRoles);

      // Get current mode from storage or determine from roles
      final currentMode =
          await _determineCurrentMode(availableModes, userRoles);

      // Create user mode model
      _userMode = UserModeModel(
        currentMode: currentMode,
        availableModes: availableModes,
        isModeSwitchEnabled: availableModes.length > 1,
        lastUpdated: DateTime.now(),
        lastUpdatedBy: 'system',
        // permissionManager: _permissionManager,
      );

      log("ProfileRepository: Initialized user mode - Current: ${currentMode.displayName}, Available: ${availableModes.map((m) => m.displayName).join(', ')}");

      await _profileLocal.setUserMode(_userMode!);
      _isInitialized = true;
      _clearError();
    } catch (e) {
      log("ProfileRepository: Error initializing user mode: $e");
      _setError('Failed to initialize user mode: ${e.toString()}');
      _setFallbackUserMode();
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> switchMode(UserMode newMode) async {
    if (_isLoading) {
      log("ProfileRepository: Already loading, cannot switch mode");
      return false;
    }

    log("ProfileRepository: Switching to $newMode");

    if (!_validateModeSwitch(newMode)) {
      return false;
    }

    if (currentMode == newMode) {
      log("ProfileRepository: Already in $newMode mode");
      return true;
    }

    // Find the role ID for the target mode
    final roleId = await _findRoleIdForMode(newMode);
    if (roleId == null) {
      log("ProfileRepository: No role found for mode $newMode");
      _setError('No role found for ${newMode.displayName}');
      return false;
    }

    // Use the role ID to switch mode via API
    return await switchModeWithRoleId(roleId);
  }

  @override
  Future<bool> switchToDriverMode() async {
    return await switchMode(UserMode.rider);
  }

  @override
  Future<bool> switchToPassengerMode() async {
    return await switchMode(UserMode.passenger);
  }

  @override
  Future<void> loadUserMode() async {
    if (_isLoading) {
      log("ProfileRepository: Already loading, skipping load");
      return;
    }

    _setLoading(true);
    try {
      final storedUserMode = await _profileLocal.getUserMode();
      if (storedUserMode != null && storedUserMode.isModeValid) {
        _userMode = storedUserMode;
        // _permissionManager = storedUserMode.permissionManager;
        _isInitialized = true;
        log("ProfileRepository: Loaded user mode from storage - ${storedUserMode.currentMode.displayName}");
      } else {
        log("ProfileRepository: No valid user mode in storage, setting default");
        _setFallbackUserMode();
      }
      _clearError();
    } catch (e) {
      log("ProfileRepository: Error loading user mode: $e");
      _setError('Failed to load user mode: ${e.toString()}');
      _setFallbackUserMode();
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> updateAvailableModes(List<UserMode> newAvailableModes) async {
    if (newAvailableModes.isEmpty) {
      _setError('At least one mode must be available');
      return;
    }

    if (_isLoading) {
      log("ProfileRepository: Already loading, cannot update modes");
      return;
    }

    _setLoading(true);
    try {
      final validCurrentMode = newAvailableModes.contains(currentMode)
          ? currentMode
          : newAvailableModes.first;

      _userMode = _userMode?.copyWith(
        currentMode: validCurrentMode,
        availableModes: newAvailableModes,
        isModeSwitchEnabled: newAvailableModes.length > 1,
        lastUpdated: DateTime.now(),
        lastUpdatedBy: 'system',
      );

      await _profileLocal.setUserMode(_userMode!);
      log("ProfileRepository: Updated available modes to ${newAvailableModes.map((m) => m.displayName).join(', ')}");
      _clearError();
    } catch (e) {
      log("ProfileRepository: Error updating available modes: $e");
      _setError('Failed to update available modes: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> clearUserMode() async {
    try {
      await _profileLocal.clearUserMode();
      await _profileLocal.clearUserRoles(); // Also clear user roles
      _userMode = null;
      _lastUserData = null;
      // _permissionManager = null;
      _isInitialized = false;
      _cachedUserRoles = null; // Clear cached user roles
      log("ProfileRepository: Cleared user mode and user roles data");
      _clearError();
    } catch (e) {
      log("ProfileRepository: Error clearing user mode: $e");
      _setError('Failed to clear user mode: ${e.toString()}');
    }
  }

  // Profile Data Methods with User Mode Integration
  @override
  Future<UserDataResponse> getUserData() async {
    try {
      final userData = await _profileRemote.getUserData();
      _lastUserData = userData;

      // Update user mode based on new user data if roles changed
      await _updateUserModeFromUserData(userData);

      return userData;
    } catch (e) {
      log("ProfileRepository: Error getting user data: $e");
      rethrow;
    }
  }

  @override
  Future<AppVersionModel> getAppVersion() async {
    return await getAppVersion();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _setFallbackUserMode() {
    _userMode = UserModeModel(
      currentMode: UserMode.passenger,
      availableModes: [UserMode.passenger, UserMode.rider],
      isModeSwitchEnabled: true,
      lastUpdated: DateTime.now(),
      lastUpdatedBy: 'fallback',
      // permissionManager: _permissionManager,
    );
    _isInitialized = true;
  }

  List<UserMode> _parseAvailableModesFromRoles(List<RoleModel>? userRoles) {
    if (userRoles == null || userRoles.isEmpty) {
      log("ProfileRepository: No roles provided, defaulting to passenger mode only");
      return [UserMode.passenger];
    }

    final availableModes = <UserMode>{};

    for (final role in userRoles) {
      if (role.isActiveRole == true) {
        if (UserMode.rider.matchesRoleCode(role.roleCode)) {
          availableModes.add(UserMode.rider);
        }
        if (UserMode.passenger.matchesRoleCode(role.roleCode)) {
          availableModes.add(UserMode.passenger);
        }
      }
    }

    // Always ensure passenger mode is available as fallback
    availableModes.add(UserMode.passenger);

    log("ProfileRepository: Parsed modes from roles: ${availableModes.map((m) => m.displayName).join(', ')}");
    return availableModes.toList();
  }

  Future<UserMode> _determineCurrentMode(
      List<UserMode> availableModes, List<RoleModel>? userRoles) async {
    // Try to get current mode from storage first
    final storedMode = await _profileLocal.getCurrentMode();
    if (availableModes.contains(storedMode)) {
      return storedMode;
    }

    // Determine from roles if storage mode is not available
    if (userRoles != null) {
      // Check for primary driver role
      final primaryDriverRole = userRoles.firstWhere(
        (role) =>
            role.isPrimary == true &&
            UserMode.rider.matchesRoleCode(role.roleCode),
        orElse: () => RoleModel(),
      );

      if (primaryDriverRole.roleCode != null &&
          availableModes.contains(UserMode.rider)) {
        return UserMode.rider;
      }
    }

    // Default to first available mode (should be passenger)
    return availableModes.first;
  }

  bool _validateModeSwitch(UserMode newMode) {
    if (!isModeSwitchEnabled) {
      _setError('Mode switching is disabled');
      return false;
    }

    if (!availableModes.contains(newMode)) {
      _setError('Cannot switch to ${newMode.displayName} - mode not available');
      return false;
    }

    return true;
  }

  Future<void> _updateUserModeFromUserData(UserDataResponse userData) async {
    try {
      // Extract permissions from user data
      final allPermissions = <String>{};
      for (final role in userData.roles ?? []) {
        allPermissions.addAll(role.permissions ?? []);
      }
      // _permissionManager = PermissionManager(allPermissions.toList());

      // Convert UserDataResponse roles to RoleModel for consistency
      final roleModels = userData.roles
          ?.map((role) => RoleModel(
                id: int.tryParse(role.id ?? ''),
                roleCode: role.name,
                isActiveRole: true,
                isPrimary: false,
              ))
          .toList();

      // Check if available modes need updating
      final newAvailableModes = _parseAvailableModesFromRoles(roleModels);
      final currentAvailableModes = availableModes;

      // Update if modes changed
      if (!_areModesEqual(newAvailableModes, currentAvailableModes)) {
        log("ProfileRepository: User roles changed, updating available modes");
        await updateAvailableModes(newAvailableModes);
      }

      // Update permission manager in user mode
      if (_userMode != null) {
        // _userMode = _userMode!.copyWith(permissionManager: _permissionManager);
        await _profileLocal.setUserMode(_userMode!);
      }

      log("ProfileRepository: Updated permissions - ${allPermissions.length} permissions available");
    } catch (e) {
      log("ProfileRepository: Error updating user mode from user data: $e");
    }
  }

  bool _areModesEqual(List<UserMode> modes1, List<UserMode> modes2) {
    if (modes1.length != modes2.length) return false;
    for (int i = 0; i < modes1.length; i++) {
      if (modes1[i] != modes2[i]) return false;
    }
    return true;
  }

  @override
  Future<FetchListResponse<UserRoleResponse>> fetchUserRoles() async {
    // Check if we have cached data first
    if (_cachedUserRoles != null) {
      log("ProfileRepository: Returning cached user roles");
      return _cachedUserRoles!;
    }

    // Try to load from local storage
    final storedUserRoles = await _profileLocal.getUserRoles();
    if (storedUserRoles != null) {
      log("ProfileRepository: Loading user roles from local storage");
      _cachedUserRoles = storedUserRoles;
      return storedUserRoles;
    }

    // Fetch from remote if no cached data
    log("ProfileRepository: Fetching user roles from remote");
    final response = await _profileRemote.fetchUserRoles();

    // Cache the response
    _cachedUserRoles = response;
    await _profileLocal.setUserRoles(response);

    log("ProfileRepository: Cached user roles data");
    return response;
  }

  @override
  Future<void> clearUserRoles() async {
    log("ProfileRepository: Clearing cached user roles");
    _cachedUserRoles = null;
    await _profileLocal.clearUserRoles();
  }

  @override
  Future<bool> switchModeWithRoleId(String roleId) async {
    if (_isLoading) {
      log("ProfileRepository: Already loading, cannot switch mode");
      return false;
    }

    log("ProfileRepository: Switching to role ID: $roleId");

    _setLoading(true);
    try {
      log("ProfileRepository: Calling remote API to switch mode");
      final switchResponse = await _profileRemote.switchMode(roleId);

      // Handle token management
      await _handleTokenUpdate(switchResponse);

      // Find the corresponding UserMode for this role
      final targetMode = await _findModeForRoleId(roleId);
      if (targetMode == null) {
        log("ProfileRepository: Could not determine mode for role ID: $roleId");
        _setError('Could not determine mode for role');
        return false;
      }

      // Update user mode with timestamp
      _userMode = _userMode?.copyWith(
        currentMode: targetMode,
        lastUpdated: DateTime.now(),
        lastUpdatedBy: 'user',
      );

      // Save to storage
      await _profileLocal.setCurrentMode(targetMode);
      await _profileLocal.setUserMode(_userMode!);

      log("ProfileRepository: Successfully switched to $targetMode");
      _clearError();
      return true;
    } catch (e) {
      log("ProfileRepository: Error switching mode: $e");
      _setError('Failed to switch mode: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Handle token update from switch mode response
  Future<void> _handleTokenUpdate(SwitchUserModeResponse switchResponse) async {
    try {
      log("ProfileRepository: Handling token update");

      // Clear old token
      // await _authLocal.removeAccessToken();
      log("ProfileRepository: Old token cleared");
      await _authLocal.setAccessToken('');
      // Set new token
      await _authLocal.setAccessToken(switchResponse.accessToken);
      log("ProfileRepository: New token set successfully");

      // Update user data if available
      if (switchResponse.user != null) {
        await _authLocal.setUserId(switchResponse.user!.id);
        log("ProfileRepository: User ID updated: ${switchResponse.user!.id}");
      }

      log("ProfileRepository: Token management completed successfully");
    } catch (e) {
      log("ProfileRepository: Error handling token update: $e");
      throw Exception('Failed to update authentication token: ${e.toString()}');
    }
  }

  /// Find mode for a specific role ID
  Future<UserMode?> _findModeForRoleId(String roleId) async {
    if (_cachedUserRoles == null) {
      log("ProfileRepository: No cached user roles available");
      return null;
    }

    for (final role in _cachedUserRoles!.rows) {
      if (role.id == roleId) {
        final mode = _getModeFromRole(role);
        log("ProfileRepository: Found mode $mode for role ID $roleId");
        return mode;
      }
    }

    log("ProfileRepository: No mode found for role ID $roleId");
    return null;
  }

  /// Get mode from role
  UserMode _getModeFromRole(dynamic role) {
    final roleName = role.name.toLowerCase();
    log("ProfileRepository: Getting mode for role: $roleName");

    if (roleName.contains('rider') || roleName.contains('driver')) {
      log("ProfileRepository: Role $roleName maps to UserMode.rider");
      return UserMode.rider;
    } else if (roleName.contains('passenger')) {
      log("ProfileRepository: Role $roleName maps to UserMode.passenger");
      return UserMode.passenger;
    }
    // Default to passenger if role name doesn't match known patterns
    log("ProfileRepository: Role $roleName maps to UserMode.passenger (default)");
    return UserMode.passenger;
  }

  // Helper method to find role ID for a specific mode
  Future<String?> _findRoleIdForMode(UserMode targetMode) async {
    log("ProfileRepository: _findRoleIdForMode called for $targetMode");

    if (_cachedUserRoles == null) {
      log("ProfileRepository: No cached user roles available");
      return null;
    }

    log("ProfileRepository: Cached user roles count: ${_cachedUserRoles!.rows.length}");
    log("ProfileRepository: Cached user roles: ${_cachedUserRoles!.rows.map((r) => '${r.id}:${r.name}').join(', ')}");

    for (final role in _cachedUserRoles!.rows) {
      log("ProfileRepository: Checking role ${role.id} - ${role.name}");
      if (_doesRoleMatchMode(role, targetMode)) {
        log("ProfileRepository: Found role ID ${role.id} for mode $targetMode");
        return role.id;
      }
    }

    log("ProfileRepository: No role found for mode $targetMode");
    return null;
  }

  // Helper method to check if a role matches a mode
  bool _doesRoleMatchMode(dynamic role, UserMode mode) {
    final roleName = role.name.toLowerCase();
    final matches = _getModeFromRole(role) == mode;
    log("ProfileRepository: Role ${role.name} matches mode $mode: $matches");
    return matches;
  }

  @override
  Future<bool> assignRole(String roleId) async {
    await _profileRemote.assignRole(roleId);
    return true;
  }
}
