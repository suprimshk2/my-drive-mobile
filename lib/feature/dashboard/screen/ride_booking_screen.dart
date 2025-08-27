// pubspec.yaml dependencies needed:
/*
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.0
  location: ^5.0.3
  geocoding: ^2.1.1
  http: ^1.1.0
  geolocator: ^10.1.0
*/

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mydrivenepal/widget/widget.dart';

class RideBookingScreen extends StatefulWidget {
  @override
  _RideBookingScreenState createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  GoogleMapController? _mapController;
  // Location _location = Location();

  // Coordinates for Nepal (Kathmandu as center)
  static const LatLng _kKathmandu = LatLng(27.7172, 85.3240);

  LatLng? _currentPosition;
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  TextEditingController _pickupController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  bool _isSelectingPickup = false;
  bool _isSelectingDestination = false;

  String _distance = '';
  String _duration = '';
  double _estimatedFare = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _pickupLocation = _currentPosition;
      _updatePickupAddress();
    });

    _addMarker(_currentPosition!, 'current', 'Current Location',
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose));
  }

  // Add marker to map
  void _addMarker(
      LatLng position, String id, String infoWindow, BitmapDescriptor icon) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: position,
          infoWindow: InfoWindow(title: infoWindow),
          icon: icon,
        ),
      );
    });
  }

  // Handle map tap for location selection
  void _onMapTapped(LatLng position) {
    if (_isSelectingPickup) {
      setState(() {
        _pickupLocation = position;
        _isSelectingPickup = false;
      });
      _updatePickupAddress();
      _addMarker(position, 'pickup', 'Pickup Location',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
    } else if (_isSelectingDestination) {
      setState(() {
        _destinationLocation = position;
        _isSelectingDestination = false;
      });
      _updateDestinationAddress();
      _addMarker(position, 'destination', 'Destination',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

      if (_pickupLocation != null) {
        _getDirections();
      }
    }
  }

  // Update pickup address
  Future<void> _updatePickupAddress() async {
    if (_pickupLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _pickupLocation!.latitude,
          _pickupLocation!.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          _pickupController.text =
              '${place.street}, ${place.locality}, ${place.country}';
        }
      } catch (e) {
        print('Error getting pickup address: $e');
      }
    }
  }

  // Update destination address
  Future<void> _updateDestinationAddress() async {
    if (_destinationLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _destinationLocation!.latitude,
          _destinationLocation!.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          _destinationController.text =
              '${place.street}, ${place.locality}, ${place.country}';
        }
      } catch (e) {
        print('Error getting destination address: $e');
      }
    }
  }

  // Get directions using Google Directions API
  Future<void> _getDirections() async {
    if (_pickupLocation == null || _destinationLocation == null) return;

    // Replace with your Google Maps API key
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&'
        'destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}&'
        'key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final leg = route['legs'][0];

        setState(() {
          _distance = leg['distance']['text'];
          _duration = leg['duration']['text'];
          _estimatedFare = _calculateFare(leg['distance']['value']);
        });

        // Draw polyline
        _drawPolyline(route['overview_polyline']['points']);
      }
    } catch (e) {
      print('Error getting directions: $e');
    }
  }

  // Calculate estimated fare (customize according to your rates)
  double _calculateFare(int distanceInMeters) {
    double distanceInKm = distanceInMeters / 1000;
    double baseFare = 50.0; // NPR 50 base fare
    double perKmRate = 20.0; // NPR 20 per km
    return baseFare + (distanceInKm * perKmRate);
  }

  // Draw polyline on map
  void _drawPolyline(String encodedPolyline) {
    List<LatLng> polylineCoordinates = _decodePolyline(encodedPolyline);

    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 4,
        ),
      );
    });

    // Fit camera to show entire route
    _fitCameraToRoute(polylineCoordinates);
  }

  // Decode polyline algorithm
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return polyline;
  }

  // Fit camera to show the route
  void _fitCameraToRoute(List<LatLng> coordinates) {
    if (coordinates.isEmpty) return;

    double minLat = coordinates.first.latitude;
    double maxLat = coordinates.first.latitude;
    double minLng = coordinates.first.longitude;
    double maxLng = coordinates.first.longitude;

    for (LatLng coord in coordinates) {
      minLat = coord.latitude < minLat ? coord.latitude : minLat;
      maxLat = coord.latitude > maxLat ? coord.latitude : maxLat;
      minLng = coord.longitude < minLng ? coord.longitude : minLng;
      maxLng = coord.longitude > maxLng ? coord.longitude : maxLng;
    }

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      padding: 0,
      appbarTitle: 'Book a Ride',
      showSideBar: true,
      child: Column(
        children: [
          // Location input fields
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // Pickup location field
                TextField(
                  controller: _pickupController,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.radio_button_checked, color: Colors.green),
                    hintText: 'Pickup location',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.my_location),
                      onPressed: () {
                        setState(() {
                          _isSelectingPickup = true;
                          _isSelectingDestination = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Tap on map to select pickup location')),
                        );
                      },
                    ),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 12),
                // Destination field
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on, color: Colors.red),
                    hintText: 'Where to?',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSelectingDestination = true;
                          _isSelectingPickup = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Tap on map to select destination')),
                        );
                      },
                    ),
                  ),
                  readOnly: true,
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? _kKathmandu,
                zoom: 14.0,
              ),
              markers: _markers,
              polylines: _polylines,
              onTap: _onMapTapped,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.terrain,
            ),
          ),

          // Ride details and booking
          if (_distance.isNotEmpty && _duration.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Distance: $_distance'),
                          Text('Duration: $_duration'),
                          Text(
                              'Estimated Fare: NPR ${_estimatedFare.toStringAsFixed(0)}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showBookingConfirmation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text('Book Ride',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pickup: ${_pickupController.text}'),
              SizedBox(height: 8),
              Text('Destination: ${_destinationController.text}'),
              SizedBox(height: 8),
              Text('Distance: $_distance'),
              Text('Duration: $_duration'),
              Text('Fare: NPR ${_estimatedFare.toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Ride booked successfully! Finding driver...')),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}
