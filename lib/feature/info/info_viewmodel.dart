import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mydrivenepal/shared/shared.dart';

import '../../data/model/model.dart';
import 'constant/constant.dart';
import 'constant/enums.dart';
import 'data/info_repo.dart';
import 'data/model/model.dart';

class InfoViewModel extends ChangeNotifier {
  final InfoRepo _infoRepo;

  InfoViewModel({required InfoRepo infoRepo}) : _infoRepo = infoRepo;

  int offSet = 1;
  int _totalCount = 0;
  String _keyword = '';
  String get keyword => _keyword;

  Timer? _debounce;
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;
  setHasMoreData(bool value) {
    _hasMoreData = value;
    notifyListeners();
  }

  bool _isMoreDataLoading = false;
  bool get isMoreDataLoading => _isMoreDataLoading;

  setIsMoreDataLoading(bool value) {
    _isMoreDataLoading = value;
    notifyListeners();
  }

  List<InfoResponseModel> _linksList = [];
  List<InfoResponseModel> get linksList => _linksList;
  List<InfoResponseModel> _documentsList = [];
  List<InfoResponseModel> get documentsList => _documentsList;
  int get infoTotalCount => _totalCount;
  bool _isSearchInProgress = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set setDownloadLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Response<List<InfoResponseModel>> _documentsListUseCase =
      Response<List<InfoResponseModel>>();

  set setDocumentsListUseCase(Response<List<InfoResponseModel>> response) {
    _documentsListUseCase = response;
    notifyListeners();
  }

  Response<List<InfoResponseModel>> get documentsListUseCase =>
      _documentsListUseCase;

  void resetPagination() {
    _linksList.clear();
    _documentsList.clear();
    offSet = 1;
    _totalCount = 0;
  }

  Future<void> fetchDocumentsList(
      {bool isInitialFetch = false, bool isSearch = false}) async {
    if (_isSearchInProgress) return;
    _isSearchInProgress = true;

    if (isInitialFetch) {
      setDocumentsListUseCase = Response.loading();
      setHasMoreData(true);
      _documentsList.clear();
    } else {
      if (!hasMoreData) {
        _isSearchInProgress = false;
        return;
      }

      setIsMoreDataLoading(true);
    }
    if (isSearch || isInitialFetch) {
      setDocumentsListUseCase = Response.loading();
      resetPagination();
    }

    try {
      final pagination = PaginationRequestModel(
        page: offSet,
        limit: PAGINATION_LIMIT,
        sortBy: PAGINATION_SORT_BY,
        sortOrder: PAGINATION_SORT_ORDER,
        keyword: keyword,
      );

      final data = await _infoRepo.fetchInfoList(
        pagination,
        InformationType.DOCUMENT,
      );

      if (data.rows.isEmpty) {
        resetPagination();
      } else {
        _documentsList.addAll(data.rows);
      }

      if (_documentsList.length >= data.count) {
        setHasMoreData(false);
      }
      if (data.count > 0) {
        offSet = offSet + 1;
      }
      setDocumentsListUseCase = Response.complete(_documentsList);
    } catch (e) {
      setDocumentsListUseCase = Response.error(e);
    } finally {
      _isSearchInProgress = false;
      setIsMoreDataLoading(false);
    }
  }

  void handleDocumentsSearch(String query) {
    _keyword = query;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (_keyword.isEmpty) {
      resetPagination();
      fetchDocumentsList(isInitialFetch: true, isSearch: true);
      return;
    }
    if (_keyword.length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        if (!_isSearchInProgress) {
          fetchDocumentsList(isInitialFetch: true, isSearch: true);
        }
      });
    }
    notifyListeners();
  }

  Response<List<InfoResponseModel>> _linksListUseCase =
      Response<List<InfoResponseModel>>();

  set setLinksListUseCase(Response<List<InfoResponseModel>> response) {
    _linksListUseCase = response;
    notifyListeners();
  }

  Response<List<InfoResponseModel>> get linksListUseCase => _linksListUseCase;

  void handleLinksSearch(String query) {
    _keyword = query;

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (_keyword.isEmpty) {
      resetPagination();
      fetchLinksList(isInitialFetch: true, isSearch: true);
      return;
    }
    if (_keyword.length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        if (!_isSearchInProgress) {
          fetchLinksList(isInitialFetch: true, isSearch: true);
        }
      });
    }
    notifyListeners();
  }

  Future<void> fetchLinksList(
      {bool isInitialFetch = false, bool isSearch = false}) async {
    if (_isSearchInProgress) return;
    _isSearchInProgress = true;

    if (isInitialFetch) {
      setLinksListUseCase = Response.loading();
      setHasMoreData(true);
      _linksList.clear();
    } else {
      if (!hasMoreData) {
        _isSearchInProgress = false;
        return;
      }

      setIsMoreDataLoading(true);
    }
    if (isSearch || isInitialFetch) {
      setLinksListUseCase = Response.loading();
      resetPagination();
    }

    try {
      final pagination = PaginationRequestModel(
        page: offSet,
        limit: PAGINATION_LIMIT,
        sortBy: PAGINATION_SORT_BY,
        sortOrder: PAGINATION_SORT_ORDER,
        keyword: keyword,
      );

      final data = await _infoRepo.fetchInfoList(
        pagination,
        InformationType.LINK,
      );

      if (data.rows.isEmpty) {
        resetPagination();
      } else {
        _linksList.addAll(data.rows);
      }

      if (_linksList.length >= data.count) {
        setHasMoreData(false);
      }
      if (data.count > 0) {
        offSet = offSet + 1;
      }
      setLinksListUseCase = Response.complete(_linksList);
    } catch (e) {
      setLinksListUseCase = Response.error(e);
    } finally {
      _isSearchInProgress = false;
      setIsMoreDataLoading(false);
    }
  }
}

Map<String, List<InfoResponseModel>> segregateFiles(
    List<InfoResponseModel> result) {
  List<InfoResponseModel> links = [];
  List<InfoResponseModel> documents = [];
  // TODO: need to update this after api response is updated (i.e document type)
  for (var item in result) {
    if (item.documentPath != null &&
        (item.documentPath.endsWith('_pdf') ||
            item.documentPath.endsWith('_xlsx') ||
            item.documentPath.endsWith('_txt') ||
            item.documentPath.endsWith('_jpeg') ||
            item.documentPath.endsWith('_jpg') ||
            item.documentPath.endsWith('_png') ||
            item.documentPath.endsWith('_xls') ||
            item.documentPath.endsWith('_docx'))) {
      documents.add(item);
    } else {
      links.add(item);
    }
  }

  return {'links': links, 'documents': documents};
}
