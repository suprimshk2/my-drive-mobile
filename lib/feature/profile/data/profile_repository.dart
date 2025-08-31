import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_mode_model.dart';
import 'package:mydrivenepal/feature/profile/data/models/permission_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_role_response.dart';

abstract class ProfileRepository {
  // User mode methods
  Future<void> initializeUserMode(List<RoleModel>? userRoles);
  Future<bool> switchMode(UserMode newMode);
  Future<bool> switchToDriverMode();
  Future<bool> switchToPassengerMode();
  Future<void> loadUserMode();
  Future<void> updateAvailableModes(List<UserMode> newAvailableModes);
  Future<void> clearUserMode();

  // User mode getters
  UserModeModel? get userMode;
  bool get isLoading;
  String? get errorMessage;
  UserMode get currentMode;
  List<UserMode> get availableModes;
  bool get isDriverMode;
  bool get isPassengerMode;
  bool get canSwitchToDriver;
  bool get canSwitchToPassenger;
  bool get isModeSwitchEnabled;

  // Permission getters
  // PermissionManager? get permissionManager;

  // Additional getters for better state management
  bool get isInitialized;
  UserDataResponse? get lastUserData;

  // Profile data methods
  Future<UserDataResponse> getUserData();
  Future<AppVersionModel> getAppVersion();

  // User role methods
  Future<FetchListResponse<UserRoleResponse>> fetchUserRoles();

  // Cached user roles getter
  FetchListResponse<UserRoleResponse>? get cachedUserRoles;

  // Clear cached user roles
  Future<void> clearUserRoles();

  /// Switch mode using role ID
  Future<bool> switchModeWithRoleId(String roleId);
}
