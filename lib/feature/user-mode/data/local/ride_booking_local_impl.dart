import 'dart:convert';
import 'package:mydrivenepal/data/local/local.dart';
import 'package:mydrivenepal/data/local/local_storage_keys.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/ride_request_model.dart';
import 'ride_booking_local.dart';

class RideBookingLocalImpl implements RideBookingLocal {
  final LocalStorageClient _sharedPrefManager;

  RideBookingLocalImpl({
    required LocalStorageClient sharedPrefManager,
  }) : _sharedPrefManager = sharedPrefManager;

  @override
  Future<void> saveRideRequest(RideRequestModel rideRequest) async {
    final history = await getRideHistory();
    history.insert(0, rideRequest); // Add to beginning

    // Keep only last 10 rides
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }

    // Convert to JSON strings for storage
    final jsonList = history.map((ride) => ride.toJson()).toList();
    await _sharedPrefManager.setStringList(
      LocalStorageKeys.RIDE_HISTORY,
      jsonList.map((json) => json.toString()).toList(),
    );
  }

  @override
  Future<List<RideRequestModel>> getRideHistory() async {
    final jsonStrings =
        await _sharedPrefManager.getStringList(LocalStorageKeys.RIDE_HISTORY) ??
            [];
    return jsonStrings
        .map((jsonString) {
          try {
            final json = Map<String, dynamic>.from(jsonDecode(jsonString));
            return RideRequestModel.fromJson(json);
          } catch (e) {
            print('Error parsing ride history: $e');
            return null;
          }
        })
        .whereType<RideRequestModel>()
        .toList();
  }

  @override
  Future<void> clearRideHistory() async {
    await _sharedPrefManager.remove(LocalStorageKeys.RIDE_HISTORY);
  }

  @override
  Future<void> saveLastPickupLocation(String address) async {
    await _sharedPrefManager.setString(
        LocalStorageKeys.LAST_PICKUP_LOCATION, address);
  }

  @override
  Future<String?> getLastPickupLocation() async {
    return await _sharedPrefManager
        .getString(LocalStorageKeys.LAST_PICKUP_LOCATION);
  }
}
