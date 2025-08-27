import 'package:mydrivenepal/data/remote/api_client.dart';
import 'package:mydrivenepal/feature/info/constant/enums.dart';
import '../../../../data/model/model.dart';
import '../../../../shared/constant/remote_api_constant.dart';
import '../model/model.dart';
import 'info_remote.dart';

class InfoRemoteImpl implements InfoRemote {
  final ApiClient _apiClient;

  InfoRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchListResponse<InfoResponseModel>> fetchInfoList(
      PaginationRequestModel pagination,
      InformationType informationType) async {
    final paginationJson = pagination.toJson();
    final queryParams = {
      'type': informationType.value,
      ...paginationJson,
    };

    final response = await _apiClient.get(
        queryParameters: queryParams, RemoteAPIConstant.INFO_LIST);
    final adoptResponse = FetchListResponse<InfoResponseModel>.fromJson(
        response.data, InfoResponseModel.fromJsonList);
    return adoptResponse;
  }
}
