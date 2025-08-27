import 'package:mydrivenepal/data/remote/api_client.dart';

import '../../../../data/model/fetch_list_response.dart';
import '../../../../data/model/pagination_model.dart';
import '../../../../shared/constant/remote_api_constant.dart';
import '../model/eoc_list_response_model.dart';
import '../model/request_eoc_request_model.dart';
import '../model/request_eoc_response_model.dart';
import 'request_eoc_remote.dart';

class RequestEocRemoteImpl implements RequestEocRemote {
  final ApiClient _apiClient;

  RequestEocRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<RequestEocResponseModel> requestEoc(
    EocRequestModel request,
  ) async {
    final response = await _apiClient.post(
      RemoteAPIConstant.REQUEST_EOC,
      request.toJson(),
    );

    return RequestEocResponseModel.fromJson(response.data);
  }

  @override
  Future<FetchListResponse<EocListResponseModel>> fetchEocList(
      PaginationRequestModel paginationRequest) async {
    final response = await _apiClient.get(
      //TODO: dynamic pagination after api is refactored
      queryParameters: paginationRequest.toJson(),
      RemoteAPIConstant.EOC_LIST,
    );
    final adoptResponse = FetchListResponse<EocListResponseModel>.fromJson(
        response.data, EocListResponseModel.fromJsonList);
    return adoptResponse;
  }
}
