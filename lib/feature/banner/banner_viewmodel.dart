import 'package:flutter/material.dart';
import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/banner/data/banner_repo.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_request_model.dart';
import 'package:mydrivenepal/feature/banner/data/model/banner_response_model.dart';
import 'package:mydrivenepal/shared/util/response.dart';

class BannerViewModel extends ChangeNotifier {
  final BannerRepo _bannerRepo;

  BannerViewModel({required BannerRepo bannerRepo}) : _bannerRepo = bannerRepo;

  Response<FetchListResponse<BannerResponseModel>> _bannersUseCase =
      Response<FetchListResponse<BannerResponseModel>>();
  Response<FetchListResponse<BannerResponseModel>> get bannersUseCase =>
      _bannersUseCase;
  set bannersUseCase(
      Response<FetchListResponse<BannerResponseModel>> response) {
    _bannersUseCase = response;
    notifyListeners();
  }

  Future<void> fetchBanners() async {
    try {
      bannersUseCase = Response.loading();
      final requestModel = BannerRequestModel();
      final response = await _bannerRepo.fetchBanner(requestModel);

      bannersUseCase = Response.complete(response);
    } catch (exception) {
      bannersUseCase = Response.error(exception);
    }
  }

  bool _showBanner = true;
  bool get showBanner => _showBanner;
  set showBanner(bool value) {
    _showBanner = value;
    notifyListeners();
  }

  Future<bool> checkBannerViewStatus() async {
    final hasClosed = await _bannerRepo.hasClosedBanner();
    showBanner = !hasClosed;
    return _showBanner;
  }

  Future<void> closeBanner(bool closeBanner) async {
    await _bannerRepo.setHasClosedBanner(closeBanner);
    showBanner = !closeBanner;
  }
}
