import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/location_data_model.dart';
import 'package:mydrivenepal/feature/user-mode/data/remote/location_remote_data_source.dart';
import 'package:mydrivenepal/feature/user-mode/data/local/location_local_data_source.dart';

/// Repository for location data operations
abstract class LocationRepository {
  Future<LatLng?> getCurrentLocation();
  Future<bool> sendLocationToServer(LocationData location);
  Future<bool> sendBatchedLocations(List<LocationData> locations);
  Future<List<LocationData>> getLocationHistory();
  Future<void> saveLocationLocally(LocationData location);
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remoteDataSource;
  final LocationLocalDataSource _localDataSource;

  LocationRepositoryImpl({
    required LocationRemoteDataSource remoteDataSource,
    required LocationLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<LatLng?> getCurrentLocation() async {
    try {
      // Get from local source first (cached location)
      final cachedLocation = await _localDataSource.getLastKnownLocation();
      if (cachedLocation != null) {
        return LatLng(cachedLocation.latitude, cachedLocation.longitude);
      }

      // If no cached location, get from device
      final deviceLocation = await _localDataSource.getDeviceLocation();
      if (deviceLocation != null) {
        // Cache the new location
        await _localDataSource
            .saveLocation(LocationData.fromLatLng(deviceLocation));
        return deviceLocation;
      }

      return null;
    } catch (e) {
      print('LocationRepository: Error getting current location: $e');
      return null;
    }
  }

  @override
  Future<bool> sendLocationToServer(LocationData location) async {
    try {
      final success = await _remoteDataSource.sendLocation(location);
      if (success) {
        // Save to local storage on successful send
        await _localDataSource.saveLocation(location);
      }
      return success;
    } catch (e) {
      print('LocationRepository: Error sending location: $e');
      return false;
    }
  }

  @override
  Future<bool> sendBatchedLocations(List<LocationData> locations) async {
    try {
      final success = await _remoteDataSource.sendBatchedLocations(locations);
      if (success) {
        // Save all locations locally on successful send
        for (final location in locations) {
          await _localDataSource.saveLocation(location);
        }
      }
      return success;
    } catch (e) {
      print('LocationRepository: Error sending batched locations: $e');
      return false;
    }
  }

  @override
  Future<List<LocationData>> getLocationHistory() async {
    return await _localDataSource.getLocationHistory();
  }

  @override
  Future<void> saveLocationLocally(LocationData location) async {
    await _localDataSource.saveLocation(location);
  }
}
