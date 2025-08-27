import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/user-mode/data/user_mode_repository.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/user_mode_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';

class UserModeViewModel extends ChangeNotifier {
  final UserModeRepository _userModeRepository;

  UserModeViewModel({
    required UserModeRepository userModeRepository,
  }) : _userModeRepository = userModeRepository;

  // Getters that delegate to repository - single source of truth
  UserModeModel? get userMode => _userModeRepository.userMode;
  bool get isLoading => _userModeRepository.isLoading;
  String? get errorMessage => _userModeRepository.errorMessage;
  UserMode get currentMode => _userModeRepository.currentMode;
  List<UserMode> get availableModes => _userModeRepository.availableModes;
  bool get isDriverMode => _userModeRepository.isDriverMode;
  bool get isPassengerMode => _userModeRepository.isPassengerMode;
  bool get canSwitchToDriver => _userModeRepository.canSwitchToDriver;
  bool get canSwitchToPassenger => _userModeRepository.canSwitchToPassenger;
  bool get isModeSwitchEnabled => _userModeRepository.isModeSwitchEnabled;

  // Initialize user mode from user roles
  Future<void> initializeUserMode(List<RoleModel>? userRoles) async {
    await _userModeRepository.initializeUserMode(userRoles);
    notifyListeners();
  }

  // Switch to a different mode with proper state management
  Future<bool> switchMode(UserMode newMode) async {
    final success = await _userModeRepository.switchMode(newMode);
    if (success) {
      // Ensure UI is updated immediately after successful switch
      notifyListeners();
    }
    return success;
  }

  // Switch to driver mode
  Future<bool> switchToDriverMode() async {
    return await switchMode(UserMode.driver);
  }

  // Switch to passenger mode
  Future<bool> switchToPassengerMode() async {
    return await switchMode(UserMode.passenger);
  }

  // Load user mode from storage
  Future<void> loadUserMode() async {
    await _userModeRepository.loadUserMode();
    notifyListeners();
  }

  // Update available modes (e.g., when user roles change)
  Future<void> updateAvailableModes(List<UserMode> newAvailableModes) async {
    await _userModeRepository.updateAvailableModes(newAvailableModes);
    notifyListeners();
  }

  // Clear user mode data (e.g., on logout)
  Future<void> clearUserMode() async {
    await _userModeRepository.clearUserMode();
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    // This would need to be implemented in the repository
    notifyListeners();
  }

  // Test method to enable both modes for testing
  Future<void> enableTestModes() async {
    await _userModeRepository
        .updateAvailableModes([UserMode.passenger, UserMode.driver]);
    notifyListeners();
  }

  // Test method to reset to passenger mode only
  Future<void> resetToPassengerOnly() async {
    await _userModeRepository.updateAvailableModes([UserMode.passenger]);
    notifyListeners();
  }

  // Refresh current mode from repository (useful for debugging)
  void refreshCurrentMode() {
    notifyListeners();
  }
}
