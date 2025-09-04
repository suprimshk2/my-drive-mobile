import 'dart:math'; // Add this import for math functions
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Data model for location information
class LocationData {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? userId;
  final String? sessionId;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.userId,
    this.sessionId,
  });

  /// Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
      if (userId != null) 'userId': userId,
      if (sessionId != null) 'sessionId': sessionId,
    };
  }

  /// Create from LatLng
  factory LocationData.fromLatLng(LatLng location,
      {String? userId, String? sessionId}) {
    return LocationData(
      latitude: location.latitude,
      longitude: location.longitude,
      timestamp: DateTime.now(),
      userId: userId,
      sessionId: sessionId,
    );
  }

  /// Calculate distance to another location
  double distanceTo(LocationData other) {
    const double earthRadius = 6371000; // meters

    final lat1Rad = latitude * (pi / 180); // Use pi from dart:math
    final lat2Rad = other.latitude * (pi / 180);
    final deltaLat = (other.latitude - latitude) * (pi / 180);
    final deltaLon = (other.longitude - longitude) * (pi / 180);

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }
}
