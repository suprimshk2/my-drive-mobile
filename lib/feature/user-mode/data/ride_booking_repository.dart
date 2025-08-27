import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/ride_booking_model.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/ride_request_model.dart';

abstract class RideBookingRepository {
  // Location services
  Future<LatLng?> getCurrentLocation();
  Future<String> getAddressFromCoordinates(LatLng position);
  Future<Map<String, dynamic>?> getDirections(
      LatLng origin, LatLng destination);

  // Ride booking operations
  Future<bool> bookRide(RideRequestModel rideRequest);
  Future<List<RideRequestModel>> getRideHistory();
  Future<void> saveRideRequest(RideRequestModel rideRequest);
  Future<void> clearRideHistory();

  // State management
  RideBookingModel get currentState;
  bool get isLoading;
  String? get errorMessage;

  // State updates
  void updatePickupLocation(LatLng? location);
  Future<void> updateDestinationLocation(LatLng? location);
  void setSelectingPickup(bool isSelecting);
  void setSelectingDestination(bool isSelecting);
  void clearError();
  void clearCurrentState();
  void resetRideDetails();
}
