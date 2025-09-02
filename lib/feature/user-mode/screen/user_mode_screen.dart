import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/profile/screen/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode.dart';
import 'package:mydrivenepal/widget/widget.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/user-mode/passenger_mode_viewmodel.dart';
// import 'package:mydrivenepal/router/route_names.dart';

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
    final profileViewModel = locator<ProfileViewmodel>();
    profileViewModel.getUserData();
    profileViewModel.fetchUserRoles();

    _loadUserMode();
  }

  Future<void> _loadUserMode() async {
    await _userModeViewModel.loadUserMode();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModeViewModel>.value(
      value: _userModeViewModel,
      child: Consumer<ProfileViewmodel>(
          builder: (context, profileViewModel, child) {
        return Consumer<UserModeViewModel>(
          builder: (context, userModeViewModel, child) {
            log("Building UserModeScreen with currentMode: ${userModeViewModel.currentMode}");

            return ScaffoldWidget(
              padding: 0,
              showSideBar: true,
              child: Column(
                children: [
                  // Mode-specific welcome message
                  // _buildWelcomeMessage(userModeViewModel),

                  // Main content
                  Expanded(
                    child: _buildModeSpecificContent(profileViewModel),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildWelcomeMessage(UserModeViewModel userModeViewModel) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            userModeViewModel.isDriverMode ? Colors.blue[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: userModeViewModel.isDriverMode
              ? Colors.blue[200]!
              : Colors.green[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            userModeViewModel.isDriverMode
                ? Icons.directions_car
                : Icons.person,
            color: userModeViewModel.isDriverMode
                ? Colors.blue[700]
                : Colors.green[700],
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to ${userModeViewModel.currentMode.displayName} Mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: userModeViewModel.isDriverMode
                        ? Colors.blue[700]
                        : Colors.green[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userModeViewModel.isDriverMode
                      ? 'You can now accept rides and earn money'
                      : 'You can now book rides and travel safely',
                  style: TextStyle(
                    fontSize: 14,
                    color: userModeViewModel.isDriverMode
                        ? Colors.blue[600]
                        : Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildModeSpecificContent(ProfileViewmodel profileViewModel) {
    final currentMode = profileViewModel.currentMode.value;
    log("Building mode-specific content for: $currentMode");

    switch (currentMode) {
      case 'passenger':
        return ChangeNotifierProvider<PassengerModeViewModel>(
          create: (_) => locator<PassengerModeViewModel>(),
          child: PassengerModeScreen(),
        );
      case 'rider':
        return DriverModeScreen();
      default:
        return ChangeNotifierProvider<PassengerModeViewModel>(
          create: (_) => locator<PassengerModeViewModel>(),
          child: PassengerModeScreen(), // Default to passenger mode
        );
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

  // Future<void> _switchToMode(BuildContext context,
  //     UserModeViewModel userModeViewModel, UserMode newMode) async {
  //   try {
  //     // Use ProfileViewmodel for role-based switching
  //     final profileViewModel = locator<ProfileViewmodel>();
  //     final success = await profileViewModel.switchMode(newMode);

  //     if (success) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('✅ Switched to ${newMode.displayName}'),
  //           backgroundColor: Colors.green,
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('❌ Failed to switch to ${newMode.displayName}'),
  //           backgroundColor: Colors.red,
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     log("UserModeScreen: Error switching mode: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('❌ Error switching mode: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

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
