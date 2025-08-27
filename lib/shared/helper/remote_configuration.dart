import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteFireBaseConfigClass {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future initialiseConfig() async {
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 20),
        ),
      );

      await remoteConfig.fetchAndActivate();
      final remoteConfigs = remoteConfig.getAll();
      return remoteConfigs;
    } catch (e) {
      return {
        "env": [
          {"ENV": "DEV", "BASE_URL": "https://dev.api.meromakaii.com/api/main"},
          {"ENV": "QA", "BASE_URL": "https://qa.api.meromakaii.com/api/main"},
          {"ENV": "UAT", "BASE_URL": "https://uat.api.meromakaii.com/api/main"}
        ]
      };
    }
  }
}
