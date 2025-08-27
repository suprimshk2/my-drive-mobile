import 'package:mydrivenepal/feature/user-mode/data/model/user_mode_model.dart';

abstract class UserModeLocal {
  Future<void> setUserMode(UserModeModel userMode);
  Future<UserModeModel?> getUserMode();
  Future<void> setCurrentMode(UserMode mode);
  Future<UserMode> getCurrentMode();
  Future<void> setAvailableModes(List<UserMode> modes);
  Future<List<UserMode>> getAvailableModes();
  Future<void> clearUserMode();
}
