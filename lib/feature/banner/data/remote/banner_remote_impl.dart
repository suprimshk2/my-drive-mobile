import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/data/remote/api_client.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_request_model.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_response_model.dart';
import 'package:mydrivenepal/feature/banner/data/remote/banner_remote.dart';
import 'package:mydrivenepal/shared/constant/remote_api_constant.dart';

class BannerRemoteImpl implements BannerRemote {
  final ApiClient _apiClient;

  BannerRemoteImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<FetchListResponse<BannerResponseModel>> fetchBanner(
      BannerRequestModel requestModel) async {
    final response = await _apiClient.get(
      RemoteAPIConstant.BANNERS,
      queryParameters: requestModel.toJson(),
    );

    final adoptResponse = FetchListResponse<BannerResponseModel>.fromJson(
        response.data, BannerResponseModel.fromJsonList);
    return adoptResponse;
  }
}
