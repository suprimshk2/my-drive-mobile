import 'package:mydrivenepal/feature/info/constant/enums.dart';

import '../../../../data/model/model.dart';
import '../model/info_response_model.dart';

abstract class InfoRemote {
  Future<FetchListResponse<InfoResponseModel>> fetchInfoList(
      PaginationRequestModel pagination, InformationType informationType);
}
