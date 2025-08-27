import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/feature/auth/auth.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
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
}
