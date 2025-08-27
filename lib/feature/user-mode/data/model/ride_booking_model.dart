import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideBookingModel {
  final LatLng? currentPosition;
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final String pickupAddress;
  final String destinationAddress;
  final String distance;
  final String duration;
  final double estimatedFare;
  final bool isSelectingPickup;
  final bool isSelectingDestination;
  final bool isLoading;
  final String? errorMessage;
  final List<LatLng> routePolyline;

  const RideBookingModel({
    this.currentPosition,
    this.pickupLocation,
    this.destinationLocation,
    this.pickupAddress = '',
    this.destinationAddress = '',
    this.distance = '',
    this.duration = '',
    this.estimatedFare = 0.0,
    this.isSelectingPickup = false,
    this.isSelectingDestination = false,
    this.isLoading = false,
    this.errorMessage,
    this.routePolyline = const [],
  });

  RideBookingModel copyWith({
    LatLng? currentPosition,
    LatLng? pickupLocation,
    LatLng? destinationLocation,
    String? pickupAddress,
    String? destinationAddress,
    String? distance,
    String? duration,
    double? estimatedFare,
    bool? isSelectingPickup,
    bool? isSelectingDestination,
    bool? isLoading,
    String? errorMessage,
    List<LatLng>? routePolyline,
  }) {
    return RideBookingModel(
      currentPosition: currentPosition ?? this.currentPosition,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      isSelectingPickup: isSelectingPickup ?? this.isSelectingPickup,
      isSelectingDestination:
          isSelectingDestination ?? this.isSelectingDestination,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      routePolyline: routePolyline ?? this.routePolyline,
    );
  }

  bool get hasValidRoute =>
      pickupLocation != null &&
      destinationLocation != null &&
      distance.isNotEmpty &&
      duration.isNotEmpty;

  bool get canBookRide => hasValidRoute && !isLoading;
}
