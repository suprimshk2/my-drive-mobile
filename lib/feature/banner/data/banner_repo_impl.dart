import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/banner/data/banner_repo.dart';
import 'package:mydrivenepal/feature/banner/data/local/banner_local.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_request_model.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_response_model.dart';
import 'package:mydrivenepal/feature/banner/data/remote/banner_remote.dart';

class BannerRepoImpl implements BannerRepo {
  final BannerRemote _bannerRemote;
  final BannerLocal _bannerLocal;

  BannerRepoImpl({
    required BannerRemote bannerRemote,
    required BannerLocal bannerLocal,
  })  : _bannerRemote = bannerRemote,
        _bannerLocal = bannerLocal;

  @override
  Future<FetchListResponse<BannerResponseModel>> fetchBanner(
      BannerRequestModel requestModel) async {
    return await _bannerRemote.fetchBanner(requestModel);
  }

  @override
  Future<bool> hasClosedBanner() {
    return _bannerLocal.hasClosedBanner();
  }

  @override
  Future<void> setHasClosedBanner(bool value) {
    return _bannerLocal.setHasClosedBanner(value);
  }
}
