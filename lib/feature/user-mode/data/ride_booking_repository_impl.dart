import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:mydrivenepal/feature/user-mode/data/local/ride_booking_local.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/ride_booking_model.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/ride_request_model.dart';
import 'ride_booking_repository.dart';

class RideBookingRepositoryImpl implements RideBookingRepository {
  final RideBookingLocal _rideBookingLocal;

  RideBookingModel _currentState = const RideBookingModel();
  bool _isLoading = false;
  String? _errorMessage;

  RideBookingRepositoryImpl({
    required RideBookingLocal rideBookingLocal,
  }) : _rideBookingLocal = rideBookingLocal;

  // Getters
  @override
  RideBookingModel get currentState => _currentState;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  // Location services
  @override
  Future<LatLng?> getCurrentLocation() async {
    _setLoading(true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('Location services are disabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setError('Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setError('Location permissions are permanently denied');
        return null;
      }

      Position position = await Geolocator.getCurrentPosition();
      final location = LatLng(position.latitude, position.longitude);

      _updateState(_currentState.copyWith(
        currentPosition: location,
        pickupLocation: location,
      ));

      _clearError();
      return location;
    } catch (e) {
      _setError('Failed to get current location: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<String> getAddressFromCoordinates(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return 'Unknown location';
    } catch (e) {
      _setError('Failed to get address: ${e.toString()}');
      return 'Unknown location';
    }
  }

  @override
  Future<Map<String, dynamic>?> getDirections(
      LatLng origin, LatLng destination) async {
    print("--------repository getDirections called-----");
    print("--------origin: $origin-----");
    print("--------destination: $destination-----");
    
    _setLoading(true);
    try {
      String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        _setError('Google Maps API key not configured');
        print("--------API key missing-----");
        return null;
      }

      final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'key=$apiKey';

      print("--------API URL: $url-----");
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      print("--------API response status: ${data['status']}-----");

      if (data['status'] == 'OK') {
        final route = data['routes'][0];
        final leg = route['legs'][0];

        final distance = leg['distance']['text'];
        final duration = leg['duration']['text'];
        final distanceValue = leg['distance']['value'];
        final estimatedFare = _calculateFare(distanceValue);

        // Decode polyline
        final polylinePoints = route['overview_polyline']['points'];
        final decodedPolyline = _decodePolyline(polylinePoints);

        print("--------Polyline points count: ${decodedPolyline.length}-----");

        _updateState(_currentState.copyWith(
          distance: distance,
          duration: duration,
          estimatedFare: estimatedFare,
          routePolyline: decodedPolyline,
        ));

        _clearError();
        print("--------getDirections successful-----");
        return {
          'distance': distance,
          'duration': duration,
          'estimatedFare': estimatedFare,
          'polyline': polylinePoints,
        };
      } else {
        _setError('Failed to get directions: ${data['status']}');
        print("--------getDirections failed: ${data['status']}-----");
        return null;
      }
    } catch (e) {
      _setError('Failed to get directions: ${e.toString()}');
      print("--------getDirections exception: $e-----");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Ride booking operations
  @override
  Future<bool> bookRide(RideRequestModel rideRequest) async {
    _setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Save to local storage
      await _rideBookingLocal.saveRideRequest(rideRequest);

      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to book ride: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<List<RideRequestModel>> getRideHistory() async {
    try {
      return await _rideBookingLocal.getRideHistory();
    } catch (e) {
      _setError('Failed to get ride history: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<void> saveRideRequest(RideRequestModel rideRequest) async {
    try {
      await _rideBookingLocal.saveRideRequest(rideRequest);
    } catch (e) {
      _setError('Failed to save ride request: ${e.toString()}');
    }
  }

  @override
  Future<void> clearRideHistory() async {
    try {
      await _rideBookingLocal.clearRideHistory();
    } catch (e) {
      _setError('Failed to clear ride history: ${e.toString()}');
    }
  }

  // State updates
  @override
  void updatePickupLocation(LatLng? location) {
    _updateState(_currentState.copyWith(
      pickupLocation: location,
      isSelectingPickup: false,
    ));
    if (location != null) {
      _updatePickupAddress(location);
    }
  }

  @override
  Future<void> updateDestinationLocation(LatLng? location) async {
    _updateState(_currentState.copyWith(
      destinationLocation: location,
      isSelectingDestination: false,
    ));
    if (location != null) {
      await _updateDestinationAddress(location);
    }

    // Get directions if both locations are set
    if (_currentState.pickupLocation != null && location != null) {
      await getDirections(_currentState.pickupLocation!, location);
    }
  }

  @override
  void setSelectingPickup(bool isSelecting) {
    _updateState(_currentState.copyWith(
      isSelectingPickup: isSelecting,
      isSelectingDestination: false,
    ));
  }

  @override
  void setSelectingDestination(bool isSelecting) {
    _updateState(_currentState.copyWith(
      isSelectingDestination: isSelecting,
      isSelectingPickup: false,
    ));
  }

  @override
  void clearError() {
    _errorMessage = null;
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _updateState(RideBookingModel newState) {
    _currentState = newState;
  }

  Future<void> _updatePickupAddress(LatLng location) async {
    final address = await getAddressFromCoordinates(location);
    _updateState(_currentState.copyWith(pickupAddress: address));
    await _rideBookingLocal.saveLastPickupLocation(address);
  }

  Future<void> _updateDestinationAddress(LatLng location) async {
    final address = await getAddressFromCoordinates(location);
    _updateState(_currentState.copyWith(destinationAddress: address));
  }

  double _calculateFare(int distanceInMeters) {
    double distanceInKm = distanceInMeters / 1000;
    double baseFare = 50.0; // NPR 50 base fare
    double perKmRate = 20.0; // NPR 20 per km
    return baseFare + (distanceInKm * perKmRate);
  }

  // Decode Google Maps polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
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

      final p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  @override
  void clearCurrentState() {
    _currentState = const RideBookingModel();
    _errorMessage = null;
    _isLoading = false;
  }

  @override
  void resetRideDetails() {
    _currentState = _currentState.copyWith(
      distance: '',
      duration: '',
      estimatedFare: 0,
      routePolyline: [],
    );
  }
}
