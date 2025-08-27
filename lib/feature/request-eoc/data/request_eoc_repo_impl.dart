import 'package:mydrivenepal/feature/request-eoc/data/model/request_eoc_response_model.dart';

import '../../../data/model/fetch_list_response.dart';
import '../../../data/model/pagination_model.dart';
import 'model/eoc_list_response_model.dart';
import 'model/request_eoc_request_model.dart';
import 'remote/request_eoc_remote.dart';
import 'request_eoc_repo.dart';

class RequestEocRepoImpl implements RequestEocRepo {
  final RequestEocRemote _requestEocRemote;

  RequestEocRepoImpl({required RequestEocRemote requestEocRemote})
      : _requestEocRemote = requestEocRemote;

  @override
  Future<RequestEocResponseModel> requestEoc(
    EocRequestModel request,
  ) async {
    final response = await _requestEocRemote.requestEoc(request);
    return response;
  }

  @override
  Future<FetchListResponse<EocListResponseModel>> fetchEocList(
      PaginationRequestModel paginationRequest) async {
    final response = await _requestEocRemote.fetchEocList(paginationRequest);
    return response;
  }
}
