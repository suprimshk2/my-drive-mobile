import 'package:mydrivenepal/feature/info/constant/enums.dart';

import '../../../data/model/model.dart';
import 'model/model.dart';

abstract class InfoRepo {
  Future<FetchListResponse<InfoResponseModel>> fetchInfoList(
      PaginationRequestModel pagination, InformationType informationType);
}
