import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/location_data_model.dart';
import 'package:mydrivenepal/data/local/local_storage_client.dart';
import 'package:mydrivenepal/data/local/local_storage_keys.dart';

/// Local data source for location operations
abstract class LocationLocalDataSource {
  Future<LatLng?> getDeviceLocation();
  Future<LocationData?> getLastKnownLocation();
  Future<List<LocationData>> getLocationHistory();
  Future<void> saveLocation(LocationData location);
  Future<void> clearLocationHistory();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final LocalStorageClient _storage;

  LocationLocalDataSourceImpl({required LocalStorageClient storage})
      : _storage = storage;

  @override
  Future<LatLng?> getDeviceLocation() async {
    try {
      // Check permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

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

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('LocationLocalDataSource: Error getting device location: $e');
      return null;
    }
  }

  @override
  Future<LocationData?> getLastKnownLocation() async {
    try {
      final locationJson =
          await _storage.getString(LocalStorageKeys.LAST_KNOWN_LOCATION);
      if (locationJson != null) {
        final Map<String, dynamic> data = jsonDecode(locationJson);
        return LocationData(
          latitude: data['latitude'],
          longitude: data['longitude'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
        );
      }
      return null;
    } catch (e) {
      print('LocationLocalDataSource: Error getting last known location: $e');
      return null;
    }
  }

  @override
  Future<List<LocationData>> getLocationHistory() async {
    try {
      final historyJson =
          await _storage.getString(LocalStorageKeys.LOCATION_HISTORY);
      if (historyJson != null) {
        final List<dynamic> history = jsonDecode(historyJson);
        return history
            .map((item) => LocationData(
                  latitude: item['latitude'],
                  longitude: item['longitude'],
                  timestamp:
                      DateTime.fromMillisecondsSinceEpoch(item['timestamp']),
                ))
            .toList();
      }
      return [];
    } catch (e) {
      print('LocationLocalDataSource: Error getting location history: $e');
      return [];
    }
  }

  @override
  Future<void> saveLocation(LocationData location) async {
    try {
      // Save as last known location
      await _storage.setString(
        LocalStorageKeys.LAST_KNOWN_LOCATION,
        jsonEncode(location.toJson()),
      );

      // Add to history
      final history = await getLocationHistory();
      history.add(location);

      // Keep only last 100 locations
      if (history.length > 100) {
        history.removeRange(0, history.length - 100);
      }

      await _storage.setString(
        LocalStorageKeys.LOCATION_HISTORY,
        jsonEncode(history.map((l) => l.toJson()).toList()),
      );
    } catch (e) {
      print('LocationLocalDataSource: Error saving location: $e');
    }
  }

  @override
  Future<void> clearLocationHistory() async {
    await _storage.remove(LocalStorageKeys.LOCATION_HISTORY);
  }
}
