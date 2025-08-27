import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mydrivenepal/data/model/developer_option_model.dart';

import '../data/model/white_label_config_model.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 5),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  WhiteLabelConfigModel get whiteLabelConfig {
    final remoteConfigs = _remoteConfig.getAll();

    final flavor = dotenv.env["FLAVOR"];

    String holistaJsonString = remoteConfigs[flavor]?.asString() ?? '{}';
    final holistaMap = jsonDecode(holistaJsonString) as Map<String, dynamic>;

    return WhiteLabelConfigModel.fromMap(holistaMap);
  }

  List<DeveloperOptionModel> get developerOptions {
    final remoteConfigs = _remoteConfig.getAll();

    String developerOptionsString =
        remoteConfigs["DeveloperOption"]?.asString() ?? '{}';
    final developerOptionsMap =
        jsonDecode(developerOptionsString) as List<dynamic>;

    return developerOptionsMap
        .map((json) => DeveloperOptionModel.fromJson(json))
        .toList();
  }
}
