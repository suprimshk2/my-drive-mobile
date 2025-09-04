import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/location_data_model.dart';
import 'package:mydrivenepal/feature/user-mode/data/repository/location_repository.dart';
import 'package:mydrivenepal/shared/service/socket_service.dart';

/// ViewModel for managing location tracking and socket communication
class UserModeSocketViewModel extends ChangeNotifier {
  static const String _tag = 'UserModeSocketViewModel';

  // Dependencies
  final LocationRepository _locationRepository;
  final SocketService _socketService;

  // State
  bool _isInitialized = false;
  bool _isLocationTracking = false;
  bool _isSocketConnected = false;
  String? _errorMessage;

  // Location data
  LocationData? _currentLocation;
  DateTime? _lastLocationUpdate;

  // Performance metrics
  int _locationUpdatesCount = 0;
  int _locationsSentCount = 0;
  int _socketMessagesReceived = 0;

  // Location tracking
  Timer? _locationTimer;
  static const Duration _locationUpdateInterval = Duration(seconds: 5);
  static const double _minLocationChangeThreshold = 10.0; // meters

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLocationTracking => _isLocationTracking;
  bool get isSocketConnected => _isSocketConnected;
  String? get errorMessage => _errorMessage;
  LatLng? get currentLocation => _currentLocation != null
      ? LatLng(_currentLocation!.latitude, _currentLocation!.longitude)
      : null;
  DateTime? get lastLocationUpdate => _lastLocationUpdate;
  int get locationUpdatesCount => _locationUpdatesCount;
  int get locationsSentCount => _locationsSentCount;
  int get socketMessagesReceived => _socketMessagesReceived;

  UserModeSocketViewModel({
    required LocationRepository locationRepository,
    required SocketService socketService,
  })  : _locationRepository = locationRepository,
        _socketService = socketService;

  /// Initialize the view model
  Future<void> initialize() async {
    try {
      log('$_tag: Initializing UserModeSocketViewModel');

      // Initialize socket service
      await _socketService.initialize();

      // Setup listeners
      _setupServiceListeners();

      _isInitialized = true;
      _clearError();
      notifyListeners();

      log('$_tag: Initialization completed successfully');
    } catch (e) {
      log('$_tag: Initialization failed: $e');
      _setError('Initialization failed: $e');
    }
  }

  /// Setup service listeners
  void _setupServiceListeners() {
    // Listen to socket service changes
    _socketService.addListener(() {
      final wasConnected = _isSocketConnected;
      _isSocketConnected = _socketService.isConnected;

      if (wasConnected != _isSocketConnected) {
        log('$_tag: Socket connection state changed: $_isSocketConnected');
        notifyListeners();
      }
    });
  }

  /// Start location tracking
  Future<void> startTracking() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_isLocationTracking) return;

      log('$_tag: Starting location tracking');

      // Start location timer
      _locationTimer = Timer.periodic(_locationUpdateInterval, (_) {
        _updateLocation();
      });

      _isLocationTracking = true;
      _clearError();
      notifyListeners();
    } catch (e) {
      log('$_tag: Error starting tracking: $e');
      _setError('Error starting tracking: $e');
    }
  }

  /// Stop location tracking
  Future<void> stopTracking() async {
    try {
      log('$_tag: Stopping location tracking');

      _locationTimer?.cancel();
      _locationTimer = null;
      _isLocationTracking = false;

      _clearError();
      notifyListeners();
    } catch (e) {
      log('$_tag: Error stopping tracking: $e');
      _setError('Error stopping tracking: $e');
    }
  }

  /// Update location and send to server
  Future<void> _updateLocation() async {
    try {
      final latLng = await _locationRepository.getCurrentLocation();
      if (latLng == null) return;

      final newLocation = LocationData.fromLatLng(latLng);

      // Check if location has changed significantly
      if (_shouldUpdateLocation(newLocation)) {
        _currentLocation = newLocation;
        _lastLocationUpdate = DateTime.now();
        _locationUpdatesCount++;

        // Send to server
        final success =
            await _locationRepository.sendLocationToServer(newLocation);
        if (success) {
          _locationsSentCount++;
        }

        notifyListeners();
      }
    } catch (e) {
      log('$_tag: Error updating location: $e');
      _setError('Error updating location: $e');
    }
  }

  /// Check if location should be updated
  bool _shouldUpdateLocation(LocationData newLocation) {
    if (_currentLocation == null) return true;

    final distance = _currentLocation!.distanceTo(newLocation);
    return distance >= _minLocationChangeThreshold;
  }

  /// Get current location once
  Future<LatLng?> getCurrentLocation() async {
    try {
      return await _locationRepository.getCurrentLocation();
    } catch (e) {
      log('$_tag: Error getting current location: $e');
      _setError('Error getting current location: $e');
      return null;
    }
  }

  /// Disconnect socket
  void disconnectSocket() {
    _socketService.disconnect();
  }

  /// Set error message
  void _setError(String error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  /// Clear error message
  void _clearError() {
    _setError(''); // Change back to null, not empty string
  }

  /// Dispose resources
  @override
  void dispose() {
    _socketService.disconnect();
    _locationTimer?.cancel();
    super.dispose();
  }
}
