import 'package:mydrivenepal/feature/request-eoc/data/model/request_eoc_response_model.dart';

import '../../../data/model/fetch_list_response.dart';
import '../../../data/model/pagination_model.dart';
import 'model/eoc_list_response_model.dart';
import 'model/request_eoc_request_model.dart';

abstract class RequestEocRepo {
  Future<RequestEocResponseModel> requestEoc(
    EocRequestModel request,
  );
  Future<FetchListResponse<EocListResponseModel>> fetchEocList(
      PaginationRequestModel paginationRequest);
}
