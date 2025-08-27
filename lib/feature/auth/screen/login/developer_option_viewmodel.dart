import 'package:mydrivenepal/di/remote_config_service.dart';

import 'package:mydrivenepal/feature/auth/data/local/auth_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/data/model/developer_option_model.dart';

class DeveloperOptionViewModel extends ChangeNotifier {
  final RemoteConfigService _remoteConfigService;
  final AuthLocal _authLocal;

  DeveloperOptionViewModel(
      {required AuthLocal authLocal,
      required RemoteConfigService remoteConfigService})
      : _authLocal = authLocal,
        _remoteConfigService = remoteConfigService;

  late List<DeveloperOptionModel> _developerOptionList;

  String _baseUrl = dotenv.env["BASE_URL"]!;

  List<DeveloperOptionModel> get developerOptionList => _developerOptionList;
  String get baseUrl => _baseUrl;

  void setDeveloperOptionList(List<DeveloperOptionModel> value) {
    _developerOptionList = value;
  }

  void setEnvironment(String value) {
    _baseUrl = value;
    notifyListeners();
  }

  Future<bool> onChangeEnvironment(String value) async {
    try {
      setEnvironment(value);
      _authLocal.setIsRememberedMe(false);
      _authLocal.setRememberMeData("");
      return true;
    } catch (e) {
      return false;
    }
  }

  void getDeveloperOptions() {
    final devloperOptionsList = _remoteConfigService.developerOptions;
    final newDevloperOptionsList = devloperOptionsList
        .map((e) =>
            DeveloperOptionModel(env: e.env, baseUrl: e.baseUrl + '/api/'))
        .toList(); //TODO: refactor string interpolation later

    setDeveloperOptionList(newDevloperOptionsList);
  }

  Future<String> getBaseUrl() async {
    String localBaseUrl = await _authLocal.getBaseUrl();
    if (localBaseUrl.isNotEmpty) {
      setEnvironment(localBaseUrl);
    }
    return localBaseUrl;
  }

  Future<void> setBaseUrl(String value) async {
    await _authLocal.setBaseUrl(value);
    getBaseUrl();
  }
}
