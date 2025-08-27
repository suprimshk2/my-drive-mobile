import 'dart:async';

import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'data/id_card_repo.dart';
import 'id_card.dart';

class IdCardViewModel extends ChangeNotifier {
  final IdCardRepo _idCardRepo;

  IdCardViewModel({required IdCardRepo idCardRepo}) : _idCardRepo = idCardRepo;
  Response<List<IdCardResponseModel>> _idCardListResponse =
      Response<List<IdCardResponseModel>>();

  Response<List<IdCardResponseModel>> get idCardListResponse =>
      _idCardListResponse;

  set setIdCardListUseCase(Response<List<IdCardResponseModel>> response) {
    _idCardListResponse = response;
    notifyListeners();
  }

  Future<void> fetchIdCardList() async {
    try {
      setIdCardListUseCase = Response.loading();
      final response = await _idCardRepo.fetchIdCardList();
      setIdCardListUseCase = Response.complete(response.rows);
    } catch (exception) {
      setIdCardListUseCase = Response.error(exception);
    }
  }

  List<BenefitDetailModel> getEpisodeType(
      FetchListResponse<IdCardResponseModel> episodeData) {
    final episodeDetail = episodeData.rows[0].benefitDetails;
    return episodeDetail;
  }
}
