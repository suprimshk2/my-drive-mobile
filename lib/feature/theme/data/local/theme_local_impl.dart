import 'package:mydrivenepal/feature/feature.dart';
import 'package:mydrivenepal/data/data.dart';

class ThemeLocalImpl implements ThemeLocal {
  final LocalStorageClient _sharedPrefManager;

  ThemeLocalImpl({required LocalStorageClient sharedPrefManager})
      : _sharedPrefManager = sharedPrefManager;

  @override
  Future<String?> getThemeMode() async {
    return _sharedPrefManager.getString(LocalStorageKeys.THEME_MODE);
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    _sharedPrefManager.setString(LocalStorageKeys.THEME_MODE, themeMode);
  }
}
