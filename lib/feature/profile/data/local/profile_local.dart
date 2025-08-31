import 'package:mydrivenepal/feature/profile/data/models/user_mode_model.dart';
import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_role_response.dart';

abstract class ProfileLocal {
  // User mode methods
  Future<void> setUserMode(UserModeModel userMode);
  Future<UserModeModel?> getUserMode();
  Future<void> setCurrentMode(UserMode mode);
  Future<UserMode> getCurrentMode();
  Future<void> setAvailableModes(List<UserMode> modes);
  Future<List<UserMode>> getAvailableModes();
  Future<void> clearUserMode();

  // User roles caching methods
  Future<void> setUserRoles(FetchListResponse<UserRoleResponse> userRoles);
  Future<FetchListResponse<UserRoleResponse>?> getUserRoles();
  Future<void> clearUserRoles();

  // Other profile-related local storage methods can be added here
}
