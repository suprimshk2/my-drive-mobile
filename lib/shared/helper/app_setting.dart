import 'package:app_settings/app_settings.dart';

class AppSettingHelper {
  static openAppSettings(AppSettingsType type) async {
    try {
      AppSettings.openAppSettings(
        type: type,
      );
    } catch (e) {
      return false;
    }
  }
}
