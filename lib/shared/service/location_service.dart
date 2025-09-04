import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

/// High-performance location service for real-time tracking
class LocationService extends ChangeNotifier {
  static const String _tag = 'LocationService';

  // Location state
  LatLng? _currentLocation;
  Position? _lastPosition;
  StreamSubscription<Position>? _locationSubscription;

  // Location tracking
  bool _isTracking = false;
  bool _hasLocationPermission = false;
  String? _locationError;

  // Performance settings
  static const LocationAccuracy _desiredAccuracy = LocationAccuracy.high;
  static const int _distanceFilter = 10; // meters
  static const Duration _updateInterval = Duration(seconds: 5);

  // Getters
  LatLng? get currentLocation => _currentLocation;
  Position? get lastPosition => _lastPosition;
  bool get isTracking => _isTracking;
  bool get hasLocationPermission => _hasLocationPermission;
  String? get locationError => _locationError;

  // Add these getters for external access
  LocationAccuracy get desiredAccuracy => _desiredAccuracy;
  int get distanceFilter => _distanceFilter;
  Duration get updateInterval => _updateInterval;

  /// Initialize location service
  Future<void> initialize() async {
    try {
      log('$_tag: Initializing location service');
      await _checkPermissions();
      await getCurrentLocation();
    } catch (e) {
      log('$_tag: Failed to initialize: $e');
      setLocationError('Failed to initialize: $e');
    }
  }

  /// Check and request location permissions
  Future<void> _checkPermissions() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _hasLocationPermission = true;
      _clearLocationError();
    } catch (e) {
      log('$_tag: Permission check failed: $e');
      setLocationError('Permission check failed: $e');
      _hasLocationPermission = false;
    }
  }

  /// Get current location once
  Future<LatLng?> getCurrentLocation() async {
    try {
      if (!_hasLocationPermission) {
        await _checkPermissions();
        if (!_hasLocationPermission) return null;
      }

      // Use Geolocator to get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: _desiredAccuracy,
        timeLimit: Duration(seconds: 10), // Add timeout for better UX
      );

      final location = LatLng(position.latitude, position.longitude);
      updateLocation(location, position);

      return location;
    } catch (e) {
      log('$_tag: Error getting current location: $e');
      setLocationError('Error getting current location: $e');
      return null;
    }
  }

  /// Start continuous location tracking
  Future<void> startLocationTracking() async {
    try {
      if (!_hasLocationPermission) {
        await _checkPermissions();
        if (!_hasLocationPermission) return;
      }

      if (_isTracking) return;

      log('$_tag: Starting location tracking');

      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: _desiredAccuracy,
          distanceFilter: _distanceFilter,
          timeLimit: _updateInterval,
        ),
      ).listen(
        (Position position) {
          final location = LatLng(position.latitude, position.longitude);
          updateLocation(location, position);
        },
        onError: (error) {
          log('$_tag: Location stream error: $error');
          setLocationError('Location stream error: $error');
        },
      );

      _isTracking = true;
      notifyListeners();
    } catch (e) {
      log('$_tag: Error starting location tracking: $e');
      setLocationError('Error starting location tracking: $e');
    }
  }

  /// Stop location tracking
  void stopLocationTracking() {
    log('$_tag: Stopping location tracking');

    _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;

    notifyListeners();
  }

  /// Update location data - make this public for external access
  void updateLocation(LatLng location, Position position) {
    _currentLocation = location;
    _lastPosition = position;
    _clearLocationError();
    notifyListeners();

    log('$_tag: Location updated - Lat: ${location.latitude}, Lng: ${location.longitude}');
  }

  /// Set location error - make this public for external access
  void setLocationError(String error) {
    if (_locationError != error) {
      _locationError = error;
      notifyListeners();
    }
  }

  /// Clear location error
  void _clearLocationError() {
    _setLocationError(null);
  }

  /// Private method for setting location error
  void _setLocationError(String? error) {
    if (_locationError != error) {
      _locationError = error;
      notifyListeners();
    }
  }

  /// Dispose resources
  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}
