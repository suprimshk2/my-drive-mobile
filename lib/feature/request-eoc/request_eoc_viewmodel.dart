import 'dart:async';

import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/request-eoc/data/model/eoc_list_response_model.dart';
import 'package:mydrivenepal/feature/request-eoc/data/model/request_eoc_request_model.dart';
import 'package:mydrivenepal/feature/request-eoc/data/model/request_eoc_response_model.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';

import '../../data/model/pagination_model.dart';
import 'data/request_eoc_repo.dart';

class RequestEpisodeOfCareViewModel extends ChangeNotifier {
  final RequestEocRepo _requestEocRepo;

  RequestEpisodeOfCareViewModel({required RequestEocRepo requestEocRepo})
      : _requestEocRepo = requestEocRepo;

  EocRequestModel _requestEocRequestModel = EocRequestModel(
    firstName: '',
    lastName: '',
    dob: '',
    subscriberId: '',
    phone: '',
    email: '',
    contactVia: 'email',
    bundleDisplayName: '',
    eocUuid: '',
    eocName: '',
  );

  String _keyword = '';
  String _fullName = '';

  EocRequestModel get requestEocRequestModel => _requestEocRequestModel;
  String get firstName => _requestEocRequestModel.firstName;
  String get lastName => _requestEocRequestModel.lastName;
  String get dob => _requestEocRequestModel.dob;
  String get subscriberId => _requestEocRequestModel.subscriberId;
  String get phone => _requestEocRequestModel.phone;
  String get email => _requestEocRequestModel.email;
  String get contactVia => _requestEocRequestModel.contactVia;
  String get bundleDisplayName => _requestEocRequestModel.bundleDisplayName;
  String get eocUuid => _requestEocRequestModel.eocUuid;
  String get eocName => _requestEocRequestModel.eocName;

  String get keyword => _keyword;
  String get fullName => _fullName;
  Timer? _debounce;

  Response<RequestEocResponseModel> _requestEocUseCase =
      Response<RequestEocResponseModel>();

  Response<RequestEocResponseModel> get requestEocUseCase => _requestEocUseCase;
  Response<FetchListResponse<EocListResponseModel>> _eocListUseCase =
      Response<FetchListResponse<EocListResponseModel>>();

  Response<FetchListResponse<EocListResponseModel>> get eocListUseCase =>
      _eocListUseCase;

  void setPersonalInfo({
    required String firstName,
    required String lastName,
    required String dob,
    required String subscriberId,
    required String phone,
    required String email,
    required String contactVia,
  }) {
    _requestEocRequestModel = _requestEocRequestModel.copyWith(
      firstName: firstName,
      lastName: lastName,
      dob: dob,
      subscriberId: subscriberId,
      phone: phone,
      email: email,
      contactVia: contactVia,
    );
    _fullName = '$firstName $lastName';
    notifyListeners();
  }

  void setEocInfo({
    required String bundleDisplayName,
    required String eocUuid,
    required String eocName,
  }) {
    _requestEocRequestModel = _requestEocRequestModel.copyWith(
      bundleDisplayName: bundleDisplayName,
      eocUuid: eocUuid,
      eocName: eocName,
    );
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _keyword = query;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (_keyword.length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        fetchEocList();
      });
    }
    notifyListeners();
  }

  void resetForm() {
    _requestEocRequestModel = EocRequestModel(
      firstName: '',
      lastName: '',
      dob: '',
      subscriberId: '',
      phone: '',
      email: '',
      contactVia: 'email',
      bundleDisplayName: '',
      eocUuid: '',
      eocName: '',
    );
    _fullName = '';

    notifyListeners();
  }

  void setRequestEocUseCase(Response<RequestEocResponseModel> response) {
    _requestEocUseCase = response;
    notifyListeners();
  }

  void setEocListUseCase(
      Response<FetchListResponse<EocListResponseModel>> response) {
    _eocListUseCase = response;
    notifyListeners();
  }

  Future<void> fetchEocList() async {
    final query = PaginationRequestModel(
      keyword: keyword,
      limit: 1000,
      page: 1,
      sortOrder: 'desc',
      sortBy: 'id',
    );
    try {
      setEocListUseCase(Response.loading());
      final response = await _requestEocRepo.fetchEocList(query);
      setEocListUseCase(Response.complete(response));
    } catch (exception) {
      setEocListUseCase(Response.error(exception));
    }
  }

  Future<void> requestEoc(EocRequestModel request) async {
    try {
      setRequestEocUseCase(Response.loading());
      final response = await _requestEocRepo.requestEoc(request);
      setRequestEocUseCase(Response.complete(response));
      resetForm();
    } catch (exception) {
      setRequestEocUseCase(Response.error(exception));
      resetForm();
    }
  }
}
