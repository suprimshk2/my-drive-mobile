import 'package:mydrivenepal/data/data.dart';
import '../../../shared/constant/remote_api_constant.dart';
import 'dashboard_remote.dart';

class DashboardRemoteImpl implements DashboardRemote {
  final ApiClient _apiClient;

  DashboardRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<void> setDisclaimer({
    required bool disclaimerAck,
    required String userId,
  }) async {
    final response = await _apiClient.put(
      RemoteAPIConstant.SET_DISCLAIMER.replaceAll(':userId', userId),
      {
        'disclaimerAck': disclaimerAck,
      },
    );
  }
}
