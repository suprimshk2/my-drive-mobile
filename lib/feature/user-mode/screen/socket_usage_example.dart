import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode_socket_viewmodel.dart';
import 'package:mydrivenepal/widget/widget.dart';

/// Example screen showing comprehensive socket usage
class SocketUsageExample extends StatefulWidget {
  @override
  _SocketUsageExampleState createState() => _SocketUsageExampleState();
}

class _SocketUsageExampleState extends State<SocketUsageExample> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      child: Consumer<UserModeSocketViewModel>(
        builder: (context, socketViewModel, child) {
          return Column(
            children: [
              // Status overview
              _buildStatusOverview(socketViewModel),

              SizedBox(height: 16),

              // Location information
              _buildLocationInfo(socketViewModel),

              SizedBox(height: 16),

              // Performance metrics
              _buildPerformanceMetrics(socketViewModel),

              SizedBox(height: 16),

              // Control buttons
              _buildControlButtons(socketViewModel),

              SizedBox(height: 16),

              // Error display
              if (socketViewModel.errorMessage != null)
                _buildErrorDisplay(socketViewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusOverview(UserModeSocketViewModel socketViewModel) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connection Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildStatusItem(
                  'Socket',
                  socketViewModel.isSocketConnected
                      ? 'Connected'
                      : 'Disconnected',
                  socketViewModel.isSocketConnected ? Colors.green : Colors.red,
                ),
                SizedBox(width: 16),
                _buildStatusItem(
                  'Location',
                  socketViewModel.isLocationTracking ? 'Tracking' : 'Stopped',
                  socketViewModel.isLocationTracking
                      ? Colors.blue
                      : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String status, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(UserModeSocketViewModel socketViewModel) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (socketViewModel.currentLocation != null) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildLocationItem(
                      'Latitude',
                      socketViewModel.currentLocation!.latitude
                          .toStringAsFixed(6),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildLocationItem(
                      'Longitude',
                      socketViewModel.currentLocation!.longitude
                          .toStringAsFixed(6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (socketViewModel.lastLocationUpdate != null)
                _buildLocationItem(
                  'Last Update',
                  _formatDateTime(socketViewModel.lastLocationUpdate!),
                ),
            ] else
              Text(
                'No location data available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(UserModeSocketViewModel socketViewModel) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    'Location Updates',
                    socketViewModel.locationUpdatesCount.toString(),
                    Icons.location_on,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    'Messages Sent',
                    socketViewModel.locationsSentCount.toString(),
                    Icons.send,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    'Messages Received',
                    socketViewModel.socketMessagesReceived.toString(),
                    Icons.send,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.blue[600],
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildControlButtons(UserModeSocketViewModel socketViewModel) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: socketViewModel.isLocationTracking
                ? () => socketViewModel.stopTracking()
                : () => socketViewModel.startTracking(),
            icon: Icon(
              socketViewModel.isLocationTracking
                  ? Icons.stop
                  : Icons.play_arrow,
            ),
            label: Text(
              socketViewModel.isLocationTracking
                  ? 'Stop Tracking'
                  : 'Start Tracking',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: socketViewModel.isLocationTracking
                  ? Colors.red
                  : Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => socketViewModel.getCurrentLocation(),
            icon: Icon(Icons.my_location),
            label: Text('Get Location'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorDisplay(UserModeSocketViewModel socketViewModel) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[600],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              socketViewModel.errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
