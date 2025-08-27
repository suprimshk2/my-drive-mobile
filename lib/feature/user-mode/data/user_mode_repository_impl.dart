import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/user_mode_model.dart';
import 'package:mydrivenepal/feature/user-mode/data/local/user_mode_local.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';
import 'user_mode_repository.dart';
import 'dart:developer';

class UserModeRepositoryImpl implements UserModeRepository {
  final UserModeLocal _userModeLocal;

  UserModeRepositoryImpl({
    required UserModeLocal userModeLocal,
  }) : _userModeLocal = userModeLocal;

  UserModeModel? _userMode;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  @override
  UserModeModel? get userMode => _userMode;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  UserMode get currentMode => _userMode?.currentMode ?? UserMode.passenger;

  @override
  List<UserMode> get availableModes =>
      _userMode?.availableModes ?? [UserMode.passenger, UserMode.driver];

  @override
  bool get isDriverMode => currentMode == UserMode.driver;

  @override
  bool get isPassengerMode => currentMode == UserMode.passenger;

  @override
  bool get canSwitchToDriver => _userMode?.canSwitchToDriver ?? false;

  @override
  bool get canSwitchToPassenger => _userMode?.canSwitchToPassenger ?? true;

  @override
  bool get isModeSwitchEnabled => _userMode?.isModeSwitchEnabled ?? true;

  @override
  Future<void> initializeUserMode(List<RoleModel>? userRoles) async {
    _setLoading(true);
    try {
      // Check if user has both driver and passenger roles
      final hasDriverRole = userRoles?.any((role) =>
              (role.roleCode?.toLowerCase().contains('driver') ?? false)) ??
          false;
      final hasPassengerRole = userRoles?.any((role) =>
              (role.roleCode?.toLowerCase().contains('passenger') ?? false)) ??
          false;

      List<UserMode> availableModes = [];

      // Always allow passenger mode
      availableModes.add(UserMode.passenger);

      // Add driver mode if user has driver role
      if (hasDriverRole) {
        availableModes.add(UserMode.driver);
      }

      // Get current mode from storage or default to passenger
      final currentMode = await _userModeLocal.getCurrentMode();

      // Ensure current mode is in available modes
      final validCurrentMode = availableModes.contains(currentMode)
          ? currentMode
          : UserMode.passenger;

      _userMode = UserModeModel(
        currentMode: validCurrentMode,
        availableModes: availableModes,
        isModeSwitchEnabled: availableModes.length > 1,
      );

      // Save to storage
      await _userModeLocal.setUserMode(_userMode!);
      _clearError();
    } catch (e) {
      _setError('Failed to initialize user mode: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> switchMode(UserMode newMode) async {
    log("UserModeRepository: Switching to $newMode");

    if (!isModeSwitchEnabled || !availableModes.contains(newMode)) {
      log("UserModeRepository: Cannot switch to $newMode - not enabled or not available");
      _setError('Cannot switch to ${newMode.displayName}');
      return false;
    }

    if (currentMode == newMode) {
      log("UserModeRepository: Already in $newMode mode");
      return true; // Already in the requested mode
    }

    _setLoading(true);
    try {
      log("UserModeRepository: Updating local state to $newMode");
      // Update local state immediately for instant UI feedback
      _userMode = _userMode?.copyWith(currentMode: newMode);

      log("UserModeRepository: Saving to storage");
      // Save to storage
      await _userModeLocal.setCurrentMode(newMode);
      await _userModeLocal.setUserMode(_userMode!);

      log("UserModeRepository: Successfully switched to $newMode");
      _clearError();
      return true;
    } catch (e) {
      log("UserModeRepository: Error switching to $newMode: $e");
      // Revert local state on error
      _userMode = _userMode?.copyWith(currentMode: currentMode);
      _setError('Failed to switch mode: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> switchToDriverMode() async {
    return await switchMode(UserMode.driver);
  }

  @override
  Future<bool> switchToPassengerMode() async {
    return await switchMode(UserMode.passenger);
  }

  @override
  Future<void> loadUserMode() async {
    _setLoading(true);
    try {
      final storedUserMode = await _userModeLocal.getUserMode();
      if (storedUserMode != null) {
        _userMode = storedUserMode;
      } else {
        // Default to passenger mode if nothing is stored
        _userMode = UserModeModel(
          currentMode: UserMode.passenger,
          availableModes: [UserMode.passenger, UserMode.driver],
          isModeSwitchEnabled: true,
        );
      }
      _clearError();
    } catch (e) {
      _setError('Failed to load user mode: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> updateAvailableModes(List<UserMode> newAvailableModes) async {
    if (newAvailableModes.isEmpty) {
      _setError('At least one mode must be available');
      return;
    }

    _setLoading(true);
    try {
      // Ensure current mode is still available
      final validCurrentMode = newAvailableModes.contains(currentMode)
          ? currentMode
          : newAvailableModes.first;

      _userMode = _userMode?.copyWith(
        currentMode: validCurrentMode,
        availableModes: newAvailableModes,
        isModeSwitchEnabled: newAvailableModes.length > 1,
      );

      await _userModeLocal.setUserMode(_userMode!);
      _clearError();
    } catch (e) {
      _setError('Failed to update available modes: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> clearUserMode() async {
    try {
      await _userModeLocal.clearUserMode();
      _userMode = null;
      _clearError();
    } catch (e) {
      _setError('Failed to clear user mode: ${e.toString()}');
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
