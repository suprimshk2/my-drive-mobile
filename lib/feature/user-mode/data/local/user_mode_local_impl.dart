import 'package:mydrivenepal/data/local/local.dart';
import 'package:mydrivenepal/data/local/local_storage_keys.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/user_mode_model.dart';
import 'user_mode_local.dart';

class UserModeLocalImpl implements UserModeLocal {
  final LocalStorageClient _sharedPrefManager;

  UserModeLocalImpl({
    required LocalStorageClient sharedPrefManager,
  }) : _sharedPrefManager = sharedPrefManager;

  @override
  Future<void> setUserMode(UserModeModel userMode) async {
    await _sharedPrefManager.setObject(LocalStorageKeys.USER_MODE, userMode);
  }

  @override
  Future<UserModeModel?> getUserMode() async {
    return await _sharedPrefManager.getObject<UserModeModel>(
      LocalStorageKeys.USER_MODE,
      (json) => UserModeModel.fromJson(json),
    );
  }

  @override
  Future<void> setCurrentMode(UserMode mode) async {
    final currentUserMode = await getUserMode();
    final updatedUserMode = currentUserMode?.copyWith(currentMode: mode) ??
        UserModeModel(
          currentMode: mode,
          availableModes: [UserMode.passenger, UserMode.driver],
        );
    await setUserMode(updatedUserMode);
  }

  @override
  Future<UserMode> getCurrentMode() async {
    final userMode = await getUserMode();
    return userMode?.currentMode ?? UserMode.passenger;
  }

  @override
  Future<void> setAvailableModes(List<UserMode> modes) async {
    final currentUserMode = await getUserMode();
    final updatedUserMode = currentUserMode?.copyWith(availableModes: modes) ??
        UserModeModel(
          currentMode: UserMode.passenger,
          availableModes: modes,
        );
    await setUserMode(updatedUserMode);
  }

  @override
  Future<List<UserMode>> getAvailableModes() async {
    final userMode = await getUserMode();
    return userMode?.availableModes ?? [UserMode.passenger];
  }

  @override
  Future<void> clearUserMode() async {
    await _sharedPrefManager.remove(LocalStorageKeys.USER_MODE);
  }
}
