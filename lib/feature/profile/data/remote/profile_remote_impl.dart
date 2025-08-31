import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/auth/auth.dart';
import 'package:mydrivenepal/feature/profile/data/models/switch_user_mode_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_role_response.dart';
import 'package:mydrivenepal/feature/profile/data/remote/profile_remote.dart';
import 'package:mydrivenepal/shared/constant/remote_api_constant.dart';

class ProfileRemoteImpl extends ProfileRemote {
  final AuthLocal _authLocal;
  final ApiClient _apiClient;

  ProfileRemoteImpl(
      {required ApiClient apiClient, required AuthLocal authLocal})
      : _apiClient = apiClient,
        _authLocal = authLocal;

  @override
  Future<UserDataResponse> getUserData() async {
    String userIdFromResponse = await _authLocal.getUserId();
    String userId = userIdFromResponse.toString();

    String url = RemoteAPIConstant.GET_USER_DATA.replaceAll(':userId', userId);

    final response = await _apiClient.get(url);
    final userData = UserDataResponse.fromJson(response.data);

    return userData;
  }

  @override
  Future<SwitchUserModeResponse> switchMode(String roleId) async {
    String url = RemoteAPIConstant.SWITCH_USER_MODE;
    final response = await _apiClient.post(url, {
      'roleId': roleId,
    });
    return SwitchUserModeResponse.fromJson(response.data);
  }

  @override
  Future<FetchListResponse<UserRoleResponse>> fetchUserRoles() async {
    String url = RemoteAPIConstant.FETCH_USER_ROLES;
    final response = await _apiClient.get(url);
    final adoptResponse = FetchListResponse<UserRoleResponse>.fromJson(
      response.data,
      UserRoleResponse.fromJsonList,
    );
    return adoptResponse;
  }
}
