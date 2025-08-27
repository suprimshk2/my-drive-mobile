import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mydrivenepal/widget/widget.dart';

class DriverModeScreen extends StatefulWidget {
  @override
  _DriverModeScreenState createState() => _DriverModeScreenState();
}

class _DriverModeScreenState extends State<DriverModeScreen> {
  GoogleMapController? _mapController;

  static const LatLng _butwal = LatLng(27.7006, 83.4483);
  LatLng? _currentPosition;
  Set<Marker> _markers = {};

  // Driver status
  bool _isOnline = false;
  bool _isAcceptingRides = false;
  String _driverStatus = 'Offline';

  // Mock data
  double _todayEarnings = 0.0;
  int _todayRides = 0;
  double _totalEarnings = 1250.0;
  int _totalRides = 45;
  double _rating = 4.8;

  // Ride request data
  List<Map<String, dynamic>> _rideRequests = [];
  bool _hasActiveRide = false;
  Map<String, dynamic>? _activeRide;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMockData();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _addDriverMarker();
  }

  void _addDriverMarker() {
    if (_currentPosition != null) {
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('driver'),
            position: _currentPosition!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
              title: 'You',
              snippet: _driverStatus,
            ),
          ),
        );
      });
    }
  }

  void _loadMockData() {
    // Mock ride requests
    _rideRequests = [
      {
        'id': '1',
        'pickup': 'Milan Park, Butwal',
        'destination': 'Butwal View Point, Butwal',
        'distance': '2.5 km',
        'fare': '150 NPR',
        'time': '2 min ago',
        'customerName': 'Ram Shrestha',
        'customerRating': 4.5,
      },
      {
        'id': '2',
        'pickup': 'Motipur, Butwal',
        'destination': 'Bhairawa Road, Butwal',
        'distance': '1.8 km',
        'fare': '120 NPR',
        'time': '5 min ago',
        'customerName': 'Sita Tamang',
        'customerRating': 4.8,
      },
    ];
  }

  void _toggleOnlineStatus() {
    setState(() {
      _isOnline = !_isOnline;
      _driverStatus = _isOnline ? 'Online' : 'Offline';
      _isAcceptingRides = _isOnline;
    });
    _addDriverMarker();
  }

  void _acceptRide(Map<String, dynamic> ride) {
    setState(() {
      _hasActiveRide = true;
      _activeRide = ride;
      _rideRequests.removeWhere((r) => r['id'] == ride['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ride accepted! Heading to ${ride['pickup']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _completeRide() {
    setState(() {
      _hasActiveRide = false;
      _activeRide = null;
      _todayEarnings +=
          double.parse(_activeRide?['fare'].toString().split(' ')[0] ?? '0');
      _todayRides += 1;
      _totalEarnings +=
          double.parse(_activeRide?['fare'].toString().split(' ')[0] ?? '0');
      _totalRides += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ride completed! Earnings: ${_activeRide?['fare']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = _currentPosition ?? _butwal;
    return Stack(
      children: [
        // Map
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: currentPosition,
            zoom: 15.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
        ),

        // Top Status Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Online/Offline Toggle
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driver Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _driverStatus,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isOnline ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isOnline,
                      onChanged: (value) => _toggleOnlineStatus(),
                      activeColor: Colors.green,
                    ),
                  ],
                ),

                if (_isOnline) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Today',
                          value: '${_todayRides} rides',
                          subtitle: 'NPR ${_todayEarnings.toStringAsFixed(0)}',
                          icon: Icons.today,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Rating',
                          value: _rating.toString(),
                          subtitle: '${_totalRides} rides',
                          icon: Icons.star,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        // Bottom Panel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Active Ride Section
                      if (_hasActiveRide && _activeRide != null) ...[
                        _ActiveRideCard(
                          ride: _activeRide!,
                          onComplete: _completeRide,
                        ),
                      ] else if (_isOnline && _rideRequests.isNotEmpty) ...[
                        // Ride Requests Section
                        Text(
                          'Available Rides',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        ..._rideRequests
                            .map((ride) => _RideRequestCard(
                                  ride: ride,
                                  onAccept: () => _acceptRide(ride),
                                ))
                            .toList(),
                      ] else if (_isOnline) ...[
                        // No rides available
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No ride requests available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'We\'ll notify you when rides are available',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Offline message
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.offline_bolt,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'You\'re offline',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Go online to start receiving ride requests',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RideRequestCard extends StatelessWidget {
  final Map<String, dynamic> ride;
  final VoidCallback onAccept;

  const _RideRequestCard({
    required this.ride,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${ride['pickup']} → ${ride['destination']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${ride['distance']} • ${ride['time']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ride['fare'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      Text(
                        ride['customerRating'].toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[100],
                child: Text(
                  ride['customerName'].split(' ').map((n) => n[0]).join(''),
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                ride['customerName'],
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveRideCard extends StatelessWidget {
  final Map<String, dynamic> ride;
  final VoidCallback onComplete;

  const _ActiveRideCard({
    required this.ride,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car, color: Colors.blue[700]),
              SizedBox(width: 8),
              Text(
                'Active Ride',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            '${ride['pickup']} → ${ride['destination']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Fare: ${ride['fare']}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Complete Ride'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
