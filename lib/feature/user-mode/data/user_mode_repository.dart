import 'package:mydrivenepal/feature/user-mode/data/model/user_mode_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';

abstract class UserModeRepository {
  Future<void> initializeUserMode(List<RoleModel>? userRoles);
  Future<bool> switchMode(UserMode newMode);
  Future<bool> switchToDriverMode();
  Future<bool> switchToPassengerMode();
  Future<void> loadUserMode();
  Future<void> updateAvailableModes(List<UserMode> newAvailableModes);
  Future<void> clearUserMode();

  // Getters
  UserModeModel? get userMode;
  bool get isLoading;
  String? get errorMessage;
  UserMode get currentMode;
  List<UserMode> get availableModes;
  bool get isDriverMode;
  bool get isPassengerMode;
  bool get canSwitchToDriver;
  bool get canSwitchToPassenger;
  bool get isModeSwitchEnabled;
}
