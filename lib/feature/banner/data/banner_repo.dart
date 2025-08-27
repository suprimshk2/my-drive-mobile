import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_request_model.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_response_model.dart';

abstract class BannerRepo {
  Future<FetchListResponse<BannerResponseModel>> fetchBanner(
      BannerRequestModel requestModel);

  Future<bool> hasClosedBanner();
  Future<void> setHasClosedBanner(bool value);
}
