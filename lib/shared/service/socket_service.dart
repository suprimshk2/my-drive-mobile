import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/data/local/local_storage_client.dart';
import 'package:mydrivenepal/data/local/local_storage_keys.dart';
import 'dart:math';
import 'package:mydrivenepal/shared/service/location_service.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode_socket_viewmodel.dart';

/// High-performance socket service for real-time location tracking
/// Implements connection pooling, automatic reconnection, and location batching
class SocketService extends ChangeNotifier {
  static const String _tag = 'SocketService';

  // Socket instance
  IO.Socket? _socket;

  // Location service reference
  LocationService? _locationService;

  // Connection state
  bool _isConnected = false;
  bool _isConnecting = false;
  String? _connectionError;

  // Location tracking
  Timer? _locationEmitTimer;
  LatLng? _lastEmittedLocation;
  static const Duration _locationEmitInterval = Duration(seconds: 5);
  static const double _minLocationChangeThreshold = 10.0; // meters

  // Performance optimization
  final List<Map<String, dynamic>> _locationBuffer = [];
  static const int _maxBufferSize = 10;
  static const Duration _bufferFlushInterval = Duration(seconds: 2);
  Timer? _bufferFlushTimer;

  // Connection management
  Timer? _heartbeatTimer;
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);

  // Server configuration
  String? _baseUrl;
  String? _jwtToken;

  // Getters
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String? get connectionError => _connectionError;
  LatLng? get lastEmittedLocation => _lastEmittedLocation;

  // Singleton pattern
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  /// Initialize socket service
  Future<void> initialize() async {
    try {
      print('$_tag: Initializing socket service');
      await _loadConfiguration();
      await _setupSocket();
      _startHeartbeat();
      _startBufferFlushTimer();
    } catch (e) {
      print('$_tag: Failed to initialize: $e');
      _setConnectionError('Failed to initialize: $e');
    }
  }

  /// Load configuration from storage and environment
  Future<void> _loadConfiguration() async {
    try {
      final storage = locator<LocalStorageClient>();
      _jwtToken = await storage.getString(LocalStorageKeys.ACCESS_TOKEN);

      if (_jwtToken == null || _jwtToken!.isEmpty) {
        throw Exception('No access token available');
      }

      // Get base URL from your configuration
      // You can modify this based on your app's configuration
      _baseUrl = dotenv.env["BASE_URL"]!; // Replace with actual server URL

      print('$_tag: Configuration loaded - Base URL: $_baseUrl');
    } catch (e) {
      print('$_tag: Failed to load configuration: $e');
      rethrow;
    }
  }

  /// Setup socket connection with optimal configuration
  Future<void> _setupSocket() async {
    try {
      if (_baseUrl == null || _jwtToken == null) {
        throw Exception('Configuration not loaded');
      }

      // Socket.IO configuration for optimal performance
      _socket = IO.io(
        '$_baseUrl/location',
        IO.OptionBuilder()
            .setTransports(
                ['websocket']) // Use WebSocket for better performance
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(_maxReconnectAttempts)
            .setReconnectionDelay(_reconnectDelay.inMilliseconds)
            .setReconnectionDelayMax(10000)
            .setTimeout(20000)
            .setQuery({'token': _jwtToken}) // JWT token as query parameter
            .build(),
      );

      _setupSocketEventHandlers();
      _connect();
    } catch (e) {
      print('$_tag: Socket setup failed: $e');
      _setConnectionError('Socket setup failed: $e');
    }
  }

  /// Setup socket event handlers
  void _setupSocketEventHandlers() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      print('$_tag: Socket connected');
      _setConnected(true);
      _clearConnectionError();
      _reconnectAttempts = 0;
      _emitUserStatus('online');
    });

    _socket!.onDisconnect((_) {
      print('$_tag: Socket disconnected');
      _setConnected(false);
      _scheduleReconnect();
    });

    _socket!.onConnectError((error) {
      print('$_tag: Connection error: $error');
      _setConnectionError('Connection error: $error');
      _setConnected(false);
    });

    _socket!.onError((error) {
      print('$_tag: Socket error: $error');
      _setConnectionError('Socket error: $error');
    });

    // Handle incoming messages
    _socket!.on('location_update', (data) {
      _handleLocationUpdate(data);
    });

    _socket!.on('ride_request', (data) {
      _handleRideRequest(data);
    });

    _socket!.on('status_update', (data) {
      _handleStatusUpdate(data);
    });
  }

  /// Connect to socket server
  void _connect() {
    if (_socket != null && !_isConnecting && !_isConnected) {
      _setConnecting(true);
      _socket!.connect();
    }
  }

  /// Disconnect from socket server
  void disconnect() {
    print('$_tag: Disconnecting socket');
    _stopHeartbeat();
    _stopBufferFlushTimer();

    if (_socket != null) {
      _emitUserStatus('offline');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    _setConnected(false);
    _setConnecting(false);
  }

  /// Start location tracking with optimized batching
  void startLocationTracking() {
    if (!_isConnected) {
      print('$_tag: Cannot start location tracking - not connected');
      return;
    }

    print('$_tag: Starting location tracking');
    _locationEmitTimer = Timer.periodic(_locationEmitInterval, (_) {
      _emitCurrentLocation();
    });
  }

  /// Stop location tracking
  void stopLocationTracking() {
    print('$_tag: Stopping location tracking');
    _locationEmitTimer?.cancel();
    _locationEmitTimer = null;

    // Flush any remaining buffered locations
    _flushLocationBuffer();
  }

  /// Emit current location with intelligent batching
  Future<void> _emitCurrentLocation() async {
    try {
      // Get current location from your existing location service
      final currentLocation = await _getCurrentLocationFromService();
      if (currentLocation == null) {
        print('$_tag: No location available for emission');
        return;
      }

      // Check if location has changed significantly
      if (_shouldEmitLocation(currentLocation)) {
        final locationData = {
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        _addToLocationBuffer(locationData);
        _lastEmittedLocation = currentLocation;

        // Emit immediately if buffer is full or if it's been a while
        if (_locationBuffer.length >= _maxBufferSize) {
          _flushLocationBuffer();
        }
      }
    } catch (e) {
      print('$_tag: Error getting current location: $e');
    }
  }

  /// Check if location should be emitted based on change threshold
  bool _shouldEmitLocation(LatLng newLocation) {
    if (_lastEmittedLocation == null) return true;

    final distance = _calculateDistance(_lastEmittedLocation!, newLocation);
    return distance >= _minLocationChangeThreshold;
  }

  /// Calculate distance between two points in meters
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // meters

    final lat1Rad = point1.latitude * (pi / 180);
    final lat2Rad = point2.latitude * (pi / 180);
    final deltaLat = (point2.latitude - point1.latitude) * (pi / 180);
    final deltaLon = (point2.longitude - point1.longitude) * (pi / 180);

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Add location to buffer for batch processing
  void _addToLocationBuffer(Map<String, dynamic> locationData) {
    _locationBuffer.add(locationData);

    // Keep buffer size manageable
    if (_locationBuffer.length > _maxBufferSize * 2) {
      _locationBuffer.removeRange(0, _maxBufferSize);
    }
  }

  /// Flush location buffer to server
  void _flushLocationBuffer() {
    if (_locationBuffer.isEmpty || !_isConnected) return;

    try {
      final locations = List<Map<String, dynamic>>.from(_locationBuffer);
      _locationBuffer.clear();

      // Emit batched locations
      _socket!.emit('location_batch', {
        'locations': locations,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      print('$_tag: Emitted ${locations.length} batched locations');
    } catch (e) {
      print('$_tag: Error flushing location buffer: $e');
    }
  }

  /// Start buffer flush timer
  void _startBufferFlushTimer() {
    _bufferFlushTimer = Timer.periodic(_bufferFlushInterval, (_) {
      _flushLocationBuffer();
    });
  }

  /// Stop buffer flush timer
  void _stopBufferFlushTimer() {
    _bufferFlushTimer?.cancel();
    _bufferFlushTimer = null;
  }

  /// Start heartbeat timer
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      _sendHeartbeat();
    });
  }

  /// Stop heartbeat timer
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Send heartbeat to keep connection alive
  void _sendHeartbeat() {
    if (_isConnected && _socket != null) {
      _socket!.emit('heartbeat', {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': 'alive',
      });
    }
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      print('$_tag: Scheduling reconnection attempt $_reconnectAttempts');

      Timer(_reconnectDelay, () {
        if (!_isConnected) {
          _connect();
        }
      });
    } else {
      print('$_tag: Max reconnection attempts reached');
      _setConnectionError('Max reconnection attempts reached');
    }
  }

  /// Emit user status
  void _emitUserStatus(String status) {
    if (_isConnected && _socket != null) {
      _socket!.emit('user_status', {
        'status': status,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  /// Handle incoming location updates
  void _handleLocationUpdate(dynamic data) {
    try {
      print('$_tag: Received location update: $data');
      // Handle incoming location updates from other users
      // You can implement your business logic here
    } catch (e) {
      print('$_tag: Error handling location update: $e');
    }
  }

  /// Handle ride requests
  void _handleRideRequest(dynamic data) {
    try {
      print('$_tag: Received ride request: $data');
      // Handle incoming ride requests
      // You can implement your business logic here
    } catch (e) {
      print('$_tag: Error handling ride request: $e');
    }
  }

  /// Handle status updates
  void _handleStatusUpdate(dynamic data) {
    try {
      print('$_tag: Received status update: $data');
      // Handle status updates
      // You can implement your business logic here
    } catch (e) {
      print('$_tag: Error handling status update: $e');
    }
  }

  /// Get current location from existing location service
  Future<LatLng?> _getCurrentLocationFromService() async {
    try {
      if (_locationService != null) {
        return await _locationService!.getCurrentLocation();
      }
      return null;
    } catch (e) {
      print('$_tag: Error getting current location: $e');
      return null;
    }
  }

  /// Set connection state
  void _setConnected(bool connected) {
    if (_isConnected != connected) {
      _isConnected = connected;
      _isConnecting = false;
      notifyListeners();
    }
  }

  /// Set connecting state
  void _setConnecting(bool connecting) {
    if (_isConnecting != connecting) {
      _isConnecting = connecting;
      notifyListeners();
    }
  }

  /// Set connection error
  void _setConnectionError(String? error) {
    if (_connectionError != error) {
      _connectionError = error;
      notifyListeners();
    }
  }

  /// Clear connection error
  void _clearConnectionError() {
    _setConnectionError(null);
  }

  /// Set location service reference
  void setLocationService(LocationService locationService) {
    _locationService = locationService;
  }

  /// Dispose resources
  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
