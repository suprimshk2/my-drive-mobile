import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:mydrivenepal/di/service_locator.dart';

class UserModeScreen extends StatefulWidget {
  @override
  _UserModeScreenState createState() => _UserModeScreenState();
}

class _UserModeScreenState extends State<UserModeScreen> {
  late UserModeViewModel _userModeViewModel;

  @override
  void initState() {
    super.initState();
    _userModeViewModel = locator<UserModeViewModel>();
    _loadUserMode();
  }

  Future<void> _loadUserMode() async {
    await _userModeViewModel.loadUserMode();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModeViewModel>.value(
      value: _userModeViewModel,
      child: Consumer<UserModeViewModel>(
        builder: (context, userModeViewModel, child) {
          log("Building UserModeScreen with currentMode: ${userModeViewModel.currentMode}");

          return ScaffoldWidget(
            padding: 0,
            // appbarTitle: _getModeSpecificTitle(userModeViewModel.currentMode),
            showSideBar: true,
            child: Column(
              children: [
                // Test Mode Switcher (for testing purposes)
                // _buildTestModeSwitcher(context, userModeViewModel),

                // Main content
                Expanded(
                  child: _buildModeSpecificContent(userModeViewModel),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildTestModeSwitcher(
  //     BuildContext context, UserModeViewModel userModeViewModel) {
  //   return Container(
  //     margin: EdgeInsets.all(16),
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[100],
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey[300]!),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Test Mode Switcher',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.grey[700],
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           'Current Mode: ${userModeViewModel.currentMode.displayName}',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.grey[600],
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: ElevatedButton.icon(
  //                 onPressed: userModeViewModel.isLoading
  //                     ? null
  //                     : () => _switchToMode(context, userModeViewModel, UserMode.passenger),
  //                 icon: Icon(Icons.person),
  //                 label: Text('Switch to Passenger'),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: userModeViewModel.isPassengerMode
  //                       ? Colors.green
  //                       : Colors.grey,
  //                   foregroundColor: Colors.white,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 8),
  //             Expanded(
  //               child: ElevatedButton.icon(
  //                 onPressed: userModeViewModel.isLoading
  //                     ? null
  //                     : () => _switchToMode(context, userModeViewModel, UserMode.driver),
  //                 icon: Icon(Icons.directions_car),
  //                 label: Text('Switch to Driver'),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: userModeViewModel.isDriverMode
  //                       ? Colors.green
  //                       : Colors.grey,
  //                   foregroundColor: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 8),
  //         if (userModeViewModel.isLoading)
  //           Row(
  //             children: [
  //               SizedBox(
  //                   width: 16,
  //                   height: 16,
  //                   child: CircularProgressIndicator(strokeWidth: 2)),
  //               SizedBox(width: 8),
  //               Text('Switching mode...', style: TextStyle(fontSize: 12)),
  //             ],
  //           ),
  //         if (userModeViewModel.errorMessage != null)
  //           Container(
  //             padding: EdgeInsets.all(8),
  //             margin: EdgeInsets.only(top: 8),
  //             decoration: BoxDecoration(
  //               color: Colors.red[50],
  //               borderRadius: BorderRadius.circular(4),
  //               border: Border.all(color: Colors.red[200]!),
  //             ),
  //             child: Row(
  //               children: [
  //                 Icon(Icons.error, color: Colors.red, size: 16),
  //                 SizedBox(width: 8),
  //                 Expanded(
  //                   child: Text(
  //                     userModeViewModel.errorMessage!,
  //                     style: TextStyle(color: Colors.red[700], fontSize: 12),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         SizedBox(height: 8),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: OutlinedButton.icon(
  //                 onPressed: () => _enableTestModes(context, userModeViewModel),
  //                 icon: Icon(Icons.settings, size: 16),
  //                 label:
  //                     Text('Enable Both Modes', style: TextStyle(fontSize: 12)),
  //                 style: OutlinedButton.styleFrom(
  //                   foregroundColor: Colors.blue[700],
  //                   side: BorderSide(color: Colors.blue[300]!),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 8),
  //             Expanded(
  //               child: OutlinedButton.icon(
  //                 onPressed: () =>
  //                     _resetToPassengerOnly(context, userModeViewModel),
  //                 icon: Icon(Icons.refresh, size: 16),
  //                 label: Text('Reset to Passenger',
  //                     style: TextStyle(fontSize: 12)),
  //                 style: OutlinedButton.styleFrom(
  //                   foregroundColor: Colors.orange[700],
  //                   side: BorderSide(color: Colors.orange[300]!),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildModeSpecificContent(UserModeViewModel userModeViewModel) {
    final currentMode = userModeViewModel.currentMode;
    log("Building mode-specific content for: $currentMode");

    switch (currentMode) {
      case UserMode.passenger:
        return PassengerModeScreen();
      case UserMode.driver:
        return DriverModeScreen();
      default:
        return PassengerModeScreen(); // Default to passenger mode
    }
  }

  String _getModeSpecificTitle(UserMode currentMode) {
    switch (currentMode) {
      case UserMode.passenger:
        return 'Book a Ride';
      case UserMode.driver:
        return 'Driver Mode';
      default:
        return 'MyDriveNepal';
    }
  }

  Future<void> _switchToMode(BuildContext context,
      UserModeViewModel userModeViewModel, UserMode newMode) async {
    bool success;
    if (newMode == UserMode.passenger) {
      success = await userModeViewModel.switchToPassengerMode();
    } else {
      success = await userModeViewModel.switchToDriverMode();
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Switched to ${newMode.displayName}'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to switch to ${newMode.displayName}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _enableTestModes(
      BuildContext context, UserModeViewModel userModeViewModel) async {
    await userModeViewModel.enableTestModes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Both modes enabled for testing'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _resetToPassengerOnly(
      BuildContext context, UserModeViewModel userModeViewModel) async {
    await userModeViewModel.resetToPassengerOnly();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Reset to passenger mode only'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
