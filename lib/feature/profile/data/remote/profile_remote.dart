import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/switch_user_mode_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_role_response.dart';

abstract class ProfileRemote {
  Future<UserDataResponse> getUserData();
  Future<SwitchUserModeResponse> switchMode(String roleId);
  Future<FetchListResponse<UserRoleResponse>> fetchUserRoles();
  Future<void> assignRole(String roleId);
}
