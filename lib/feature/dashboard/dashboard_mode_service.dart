import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/user_mode_model.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode_viewmodel.dart'; // FIXED IMPORT
import 'package:mydrivenepal/feature/dashboard/screen/ride_booking_screen.dart';
import 'package:mydrivenepal/feature/dashboard/screen/driver_mode_screen.dart';
import 'package:mydrivenepal/di/service_locator.dart';

class DashboardModeService {
  static final DashboardModeService _instance =
      DashboardModeService._internal();
  factory DashboardModeService() => _instance;
  DashboardModeService._internal();

  final UserModeViewModel _userModeViewModel = locator<UserModeViewModel>();

  /// Get the appropriate screen based on current user mode
  Widget getCurrentModeScreen() {
    final currentMode = _userModeViewModel.currentMode;

    switch (currentMode) {
      case UserMode.passenger:
        return RideBookingScreen();
      case UserMode.driver:
        return DriverModeScreen();
      default:
        return RideBookingScreen(); // Default to passenger mode
    }
  }

  /// Switch to passenger mode
  Future<bool> switchToPassengerMode(BuildContext context) async {
    final success = await _userModeViewModel.switchToPassengerMode();

    if (success) {
      _showModeSwitchSuccess(context, 'Passenger Mode');
      return true;
    } else {
      _showModeSwitchError(context);
      return false;
    }
  }

  /// Switch to driver mode
  Future<bool> switchToDriverMode(BuildContext context) async {
    final success = await _userModeViewModel.switchToDriverMode();

    if (success) {
      _showModeSwitchSuccess(context, 'Driver Mode');
      return true;
    } else {
      _showModeSwitchError(context);
      return false;
    }
  }

  /// Get mode-specific app bar title
  String getModeSpecificTitle() {
    final currentMode = _userModeViewModel.currentMode;

    switch (currentMode) {
      case UserMode.passenger:
        return 'Book a Ride';
      case UserMode.driver:
        return 'Driver Mode';
      default:
        return 'MyDriveNepal';
    }
  }

  /// Get mode-specific subtitle
  String getModeSpecificSubtitle() {
    final currentMode = _userModeViewModel.currentMode;

    switch (currentMode) {
      case UserMode.passenger:
        return 'Find your perfect ride';
      case UserMode.driver:
        return 'Manage your rides';
      default:
        return 'Welcome to MyDriveNepal';
    }
  }

  /// Check if mode switching is enabled
  bool isModeSwitchEnabled() {
    return _userModeViewModel.isModeSwitchEnabled;
  }

  /// Get available modes
  List<UserMode> getAvailableModes() {
    return _userModeViewModel.availableModes;
  }

  /// Get current mode
  UserMode getCurrentMode() {
    return _userModeViewModel.currentMode;
  }

  /// Check if currently in driver mode
  bool isDriverMode() {
    return _userModeViewModel.isDriverMode;
  }

  /// Check if currently in passenger mode
  bool isPassengerMode() {
    return _userModeViewModel.isPassengerMode;
  }

  /// Show success message for mode switch
  void _showModeSwitchSuccess(BuildContext context, String modeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Switched to $modeName'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show error message for mode switch
  void _showModeSwitchError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Failed to switch mode'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Get mode-specific navigation items
  List<NavigationItem> getModeSpecificNavigationItems() {
    final currentMode = _userModeViewModel.currentMode;

    switch (currentMode) {
      case UserMode.passenger:
        return [
          NavigationItem(
            title: 'Book Ride',
            icon: Icons.directions_car,
            route: '/book-ride',
          ),
          NavigationItem(
            title: 'My Rides',
            icon: Icons.history,
            route: '/my-rides',
          ),
          NavigationItem(
            title: 'Favorites',
            icon: Icons.favorite,
            route: '/favorites',
          ),
        ];
      case UserMode.driver:
        return [
          NavigationItem(
            title: 'Active Rides',
            icon: Icons.directions_car,
            route: '/active-rides',
          ),
          NavigationItem(
            title: 'Earnings',
            icon: Icons.attach_money,
            route: '/earnings',
          ),
          NavigationItem(
            title: 'Schedule',
            icon: Icons.schedule,
            route: '/schedule',
          ),
        ];
      default:
        return [];
    }
  }

  /// Get mode-specific quick actions
  List<QuickAction> getModeSpecificQuickActions() {
    final currentMode = _userModeViewModel.currentMode;

    switch (currentMode) {
      case UserMode.passenger:
        return [
          QuickAction(
            title: 'Quick Book',
            icon: Icons.flash_on,
            action: () {
              // Quick booking logic
            },
          ),
          QuickAction(
            title: 'Emergency',
            icon: Icons.emergency,
            action: () {
              // Emergency booking logic
            },
          ),
        ];
      case UserMode.driver:
        return [
          QuickAction(
            title: 'Go Online',
            icon: Icons.power_settings_new,
            action: () {
              // Go online logic
            },
          ),
          QuickAction(
            title: 'Break',
            icon: Icons.coffee,
            action: () {
              // Break logic
            },
          ),
        ];
      default:
        return [];
    }
  }
}

// Helper classes for navigation and quick actions
class NavigationItem {
  final String title;
  final IconData icon;
  final String route;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback action;

  QuickAction({
    required this.title,
    required this.icon,
    required this.action,
  });
}
