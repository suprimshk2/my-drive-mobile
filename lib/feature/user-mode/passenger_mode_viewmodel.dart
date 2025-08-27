import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/feature/user-mode/data/ride_booking_repository.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/ride_booking_model.dart';
import 'package:mydrivenepal/feature/user-mode/data/model/ride_request_model.dart';
import 'package:mydrivenepal/feature/user-mode/data/places_service.dart';

class PassengerModeViewModel extends ChangeNotifier {
  final RideBookingRepository _repository;

  PassengerModeViewModel({
    required RideBookingRepository repository,
  }) : _repository = repository;

  // Getters that delegate to repository
  RideBookingModel get currentState => _repository.currentState;

  bool get isLoading => _repository.isLoading;
  String? get errorMessage => _repository.errorMessage;

  // Computed properties
  bool get hasValidRoute => currentState.hasValidRoute;
  bool get canBookRide => currentState.canBookRide;
  bool get isSelectingPickup => currentState.isSelectingPickup;
  bool get isSelectingDestination => currentState.isSelectingDestination;
  String get distance => currentState.distance;
  String get duration => currentState.duration;
  double get estimatedFare => currentState.estimatedFare;
  List<LatLng> get routePolyline => currentState.routePolyline;
  // bool get isLoadingDirections => currentState.isLoadingDirections;
  // String? get directionsError => currentState.directionsError;

  RideRequestModel? rideDetails;

  void clearCurrentState() {
    _repository.clearCurrentState();
    notifyListeners();
  }

  void clearPickupLocation() {
    _repository.updatePickupLocation(null);
    _repository.resetRideDetails();
    notifyListeners();
  }

  void clearDestinationLocation() {
    _repository.updateDestinationLocation(null);
    _repository.resetRideDetails();
    notifyListeners();
  }

  // Initialize the passenger mode
  Future<void> initialize() async {
    await _repository.getCurrentLocation();
    notifyListeners();
  }

  // Initialize and ensure current location is available
  Future<void> initializeWithLocation() async {
    await _repository.getCurrentLocation();
    notifyListeners();
  }

  // Location handling
  Future<void> getCurrentLocation() async {
    await _repository.getCurrentLocation();
    notifyListeners();
  }

  void onMapTapped(LatLng position) async {
    if (isSelectingPickup) {
      _repository.updatePickupLocation(position);
      // setHasShownBottomSheet(true);
    } else if (isSelectingDestination) {
      await _repository.updateDestinationLocation(position);
      // setHasShownBottomSheet(true);
    }
    setHasShownBottomSheet(false);

    // Trigger polyline calculation if both locations are set
    await _triggerPolylineCalculation();
    notifyListeners();
  }

  // Place search functionality
  Future<void> selectPlaceFromSearch(
      PlaceDetails placeDetails, bool isPickup) async {
    setHasShownBottomSheet(false);
    try {
      if (isPickup) {
        _repository.updatePickupLocation(placeDetails.location);
        // The repository will automatically update the address
      } else {
        await _repository.updateDestinationLocation(placeDetails.location);
        // The repository will automatically update the address and get directions
      }

      // Trigger polyline calculation if both locations are set
      await _triggerPolylineCalculation();
      notifyListeners();
    } catch (e) {
      // Handle error by updating the state directly
      _repository.clearError();
      notifyListeners();
    }
  }

  // Get current location and center map
  Future<void> getCurrentLocationAndCenter() async {
    await _repository.getCurrentLocation();
    notifyListeners();
  }

  // Debug method to test polyline functionality
  Future<void> testPolyline() async {
    print("--------viewmodel 2.0-----: ${currentState.distance}");

    if (currentState.pickupLocation != null &&
        currentState.destinationLocation != null) {
      print("--------viewmodel 2.0.1-----: ${currentState.pickupLocation}");
      print(
          "--------viewmodel 2.0.2-----: ${currentState.destinationLocation}");

      final res = await _repository.getDirections(
        currentState.pickupLocation!,
        currentState.destinationLocation!,
      );

      if (res != null) {
        setRideDetails(res);
        print("--------viewmodel 2.0.3-----: Polyline calculated successfully");
      } else {
        print("--------viewmodel 2.0.3-----: Failed to calculate polyline");
      }

      notifyListeners();
    } else {
      print(
          "--------viewmodel 2.0.1-----: Missing pickup or destination location");
    }
  }

  void setRideDetails(Map<String, dynamic> rideRequest) {
    rideDetails = RideRequestModel(
      pickupAddress: rideRequest['pickupAddress'] ?? "",
      destinationAddress: rideRequest['destinationAddress'] ?? "",
      distance: rideRequest['distance'] ?? "",
      duration: rideRequest['duration'] ?? "",
      fare: rideRequest['estimatedFare'] ?? 0,
      requestTime: DateTime.now(),
    );

    notifyListeners();
  }

  bool canUpdateLocation() {
    print("--------viewmodel 1.0-----: ${currentState.distance}");
    // Remove the testPolyline call to prevent infinite loop
    // testPolyline();
    final canUpdate = currentState.pickupLocation != null &&
        currentState.destinationLocation != null;

    return canUpdate;
  }

  // Manual method to trigger polyline calculation
  Future<void> calculateRouteIfNeeded() async {
    if (canUpdateLocation() && currentState.routePolyline.isEmpty) {
      await testPolyline();
    }
  }

  // Public method to manually trigger polyline calculation (for testing)
  Future<void> calculateRoute() async {
    await testPolyline();
  }

  // Private method to trigger polyline calculation when both locations are set
  Future<void> _triggerPolylineCalculation() async {
    if (currentState.pickupLocation != null &&
        currentState.destinationLocation != null &&
        currentState.routePolyline.isEmpty) {
      await testPolyline();
    }
  }

  bool _hasShownBottomSheet = false;
  bool get hasShownBottomSheet => _hasShownBottomSheet;
  void setHasShownBottomSheet(bool value) {
    // Only update and notify if the value actually changed
    if (_hasShownBottomSheet != value) {
      _hasShownBottomSheet = value;
      notifyListeners();
    }
  }

  // UI state management
  void startSelectingPickup() {
    // setHasShownBottomSheet(false);
    _repository.setSelectingPickup(true);
    notifyListeners();
  }

  void startSelectingDestination() {
    // setHasShownBottomSheet(false);
    _repository.setSelectingDestination(true);
    notifyListeners();
  }

  // Ride booking
  Future<bool> bookRide() async {
    if (!canBookRide) return false;

    final rideRequest = RideRequestModel(
      pickupAddress: currentState.pickupAddress,
      destinationAddress: currentState.destinationAddress,
      distance: currentState.distance,
      duration: currentState.duration,
      fare: currentState.estimatedFare,
      requestTime: DateTime.now(),
    );

    final success = await _repository.bookRide(rideRequest);
    notifyListeners();
    return success;
  }

  Future<RideRequestModel> getRideDetails() async {
    final rideRequest = RideRequestModel(
      pickupAddress: currentState.pickupAddress,
      destinationAddress: currentState.destinationAddress,
      distance: currentState.distance,
      duration: currentState.duration,
      fare: currentState.estimatedFare,
      requestTime: DateTime.now(),
    );
    notifyListeners();
    return rideRequest;
  }

  // Error handling
  void clearError() {
    _repository.clearError();
    notifyListeners();
  }

  // Ride history
  Future<List<RideRequestModel>> getRideHistory() async {
    return await _repository.getRideHistory();
  }

  Future<void> clearRideHistory() async {
    await _repository.clearRideHistory();
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
  }
}
