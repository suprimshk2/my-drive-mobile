import 'package:mydrivenepal/feature/user-mode/data/model/ride_request_model.dart';

abstract class RideBookingLocal {
  Future<void> saveRideRequest(RideRequestModel rideRequest);
  Future<List<RideRequestModel>> getRideHistory();
  Future<void> clearRideHistory();
  Future<void> saveLastPickupLocation(String address);
  Future<String?> getLastPickupLocation();
}
