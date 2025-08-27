import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_request_model.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_response_model.dart';

abstract class BannerRemote {
  Future<FetchListResponse<BannerResponseModel>> fetchBanner(
      BannerRequestModel requestModel);
}
