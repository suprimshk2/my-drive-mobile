import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/size_config.dart';
import 'package:mydrivenepal/widget/button/variants/rounded_filled_button_widget.dart';
import 'package:mydrivenepal/widget/text/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:mydrivenepal/feature/user-mode/passenger_mode_viewmodel.dart';
import 'package:mydrivenepal/di/service_locator.dart';
import 'package:mydrivenepal/feature/user-mode/widget/place_search_widget.dart';
import 'package:mydrivenepal/widget/scaffold/optimized_bottom_sheet.dart';
import 'dart:math';

import '../../../shared/util/dimens.dart';

class PassengerModeScreen extends StatefulWidget {
  @override
  _PassengerModeScreenState createState() => _PassengerModeScreenState();
}

class _PassengerModeScreenState extends State<PassengerModeScreen> {
  GoogleMapController? _mapController;
  static const LatLng _butwal = LatLng(27.7006, 83.4483);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<PassengerModeViewModel>();
      viewModel.initializeWithLocation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to route changes and fit map to route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<PassengerModeViewModel>();
      if (viewModel.currentState.routePolyline.isNotEmpty) {
        _fitMapToRoute(viewModel.currentState.routePolyline);
      }
    });
  }

  // Listen to viewModel changes to center map on current location
  void _listenToLocationChanges(PassengerModeViewModel viewModel) {
    // Center map on current location when it becomes available
    if (viewModel.currentState.currentPosition != null &&
        _mapController != null) {
      // Only center if no route is available (to avoid conflicts)
      if (viewModel.currentState.routePolyline.isEmpty) {
        _centerMapOnLocation(viewModel.currentState.currentPosition!);
      }
    }
  }

  // Force center map on current location (used for initial load)
  void _forceCenterOnCurrentLocation(PassengerModeViewModel viewModel) {
    if (viewModel.currentState.currentPosition != null &&
        _mapController != null) {
      _centerMapOnLocation(viewModel.currentState.currentPosition!);
    }
  }

  // Method to handle when current location is updated
  void _onCurrentLocationUpdated(LatLng newLocation) {
    // Center map on new location if no route is available
    if (_mapController != null) {
      _centerMapOnLocation(newLocation);
    }
  }

  // Handle initial map centering when location becomes available
  void _handleInitialCentering(PassengerModeViewModel viewModel) {
    if (viewModel.currentState.currentPosition != null &&
        _mapController != null) {
      // Use a slightly longer animation for initial centering
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: viewModel.currentState.currentPosition!,
            zoom: 16.0, // Closer zoom for better initial view
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PassengerModeViewModel>(
      create: (_) => locator<PassengerModeViewModel>(),
      child: Consumer<PassengerModeViewModel>(
        builder: (context, viewModel, child) {
          // Listen to location changes and center map
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _listenToLocationChanges(viewModel);
            // Force center on current location for initial load
            _forceCenterOnCurrentLocation(viewModel);

            // Auto-show bottom sheet when location can be updated
            // _autoShowBottomSheet(context, viewModel);
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.canUpdateLocation() &&
                !viewModel.hasShownBottomSheet) {
              viewModel
                  .setHasShownBottomSheet(true); // prevent multiple triggers
              print("--------distance-----: ${viewModel.distance}");
              _showRideDetailsBottomSheet(context, viewModel);
            }
          });
          return Column(
            children: [
              // Error message display
              if (viewModel.errorMessage != null)
                _buildErrorWidget(context, viewModel),

              // Location input fields
              _buildLocationInputs(context, viewModel),

              // Map
              Expanded(
                flex: 3,
                child: _buildMap(context, viewModel),
              ),

              // Ride details and booking
              // if (viewModel.canUpdateLocation())
              // _buildRideDetails(context, viewModel),

              // Show optimized bottom sheet button
              // if (viewModel.canUpdateLocation() &&
              //     viewModel.hasShownBottomSheet == false)
              //   _buildShowBottomSheetButton(context, viewModel),
            ],
          );
        },
      ),
    );
  }

  // Future<dynamic> _bottomSheetInfo(
  //     BuildContext context, String message, String title) {
  //   return showModalBottomSheet(
  //     context: context,
  //     isDismissible: true,
  //     isScrollControlled: false,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(16),
  //       ),
  //     ),
  //     constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight * 0.4),
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: getDeviceHeight(context, value: 0.4),
  //         padding: const EdgeInsets.symmetric(horizontal: Dimens.spacing_large),
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).canvasColor,
  //           borderRadius: const BorderRadiusDirectional.only(
  //             topEnd: Radius.circular(Dimens.spacing_large),
  //             topStart: Radius.circular(Dimens.spacing_large),
  //           ),
  //         ),
  //         child: Column(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 children: [
  //                   const SizedBox(height: Dimens.spacing_extra_large),
  //                   TextWidget(
  //                     text: title,
  //                     style: Theme.of(context).textTheme.titleMedium!,
  //                   ),
  //                   const SizedBox(height: Dimens.spacing_32),
  //                   Text(message,
  //                       textAlign: TextAlign.center,
  //                       style: Theme.of(context).textTheme.bodyMedium!),
  //                   const SizedBox(height: Dimens.spacing_32),
  //                 ],
  //               ),
  //             ),
  //             RoundedFilledButtonWidget(
  //                 context: context,
  //                 label: "Continue",
  //                 onPressed: () {
  //                   if (!context.mounted) return;
  //                   context.pop();
  //                 }),
  //             const SizedBox(height: Dimens.spacing_4),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildErrorWidget(
      BuildContext context, PassengerModeViewModel viewModel) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: TextStyle(color: Colors.red[700], fontSize: 14),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red[600], size: 16),
            onPressed: viewModel.clearError,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInputs(
      BuildContext context, PassengerModeViewModel viewModel) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Pickup location search
          PlaceSearchWidget(
            hintText: 'Pickup location',
            prefixIcon: Icons.radio_button_checked,
            prefixIconColor: Colors.green,
            currentLocation: viewModel.currentState.currentPosition,
            initialValue: viewModel.currentState.pickupAddress,
            onPlaceSelected: (placeDetails) {
              viewModel.selectPlaceFromSearch(placeDetails, true);
            },
            suffixIcon: IconButton(
              onPressed: () {
                viewModel.setHasShownBottomSheet(true);
                viewModel.clearPickupLocation();
                viewModel.startSelectingPickup();
                _showSelectionMessage(
                    context, 'Tap on map to select pickup location');
              },
              icon: Icon(Icons.my_location, size: 16),
            ),
          ),
          SizedBox(height: 12),

          // Destination search
          PlaceSearchWidget(
            hintText: 'Where to?',
            prefixIcon: Icons.location_on,
            prefixIconColor: Colors.red,
            currentLocation: viewModel.currentState.currentPosition,
            initialValue: viewModel.currentState.destinationAddress,
            onPlaceSelected: (placeDetails) {
              viewModel.selectPlaceFromSearch(placeDetails, false);
            },
            suffixIcon: IconButton(
              onPressed: () {
                viewModel.setHasShownBottomSheet(true);
                viewModel.clearDestinationLocation();
                viewModel.startSelectingDestination();
                _showSelectionMessage(
                    context, 'Tap on map to select destination');
              },
              icon: Icon(Icons.map, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context, PassengerModeViewModel viewModel) {
    final currentPosition = viewModel.currentState.currentPosition ?? _butwal;

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            // Center map on user's current location when map is created
            if (viewModel.currentState.currentPosition != null) {
              _handleInitialCentering(viewModel);
            } else {
              // If current location is not available yet, wait a bit and try again
              Future.delayed(Duration(milliseconds: 800), () {
                if (viewModel.currentState.currentPosition != null &&
                    _mapController != null) {
                  _handleInitialCentering(viewModel);
                }
              });
            }
          },
          initialCameraPosition: CameraPosition(
            target: currentPosition,
            zoom: 15.0, // Increased zoom for better visibility
          ),
          markers: _buildMarkers(viewModel),
          polylines: _buildPolylines(viewModel),
          onTap: viewModel.onMapTapped,
          myLocationEnabled: true,
          myLocationButtonEnabled:
              true, // Disable default button, we have custom one
          mapType: MapType.normal,
        ),

        // Loading overlay
        // if (viewModel.isLoading)
        //   Container(
        //     color: Colors.black.withOpacity(0.3),
        //     child: Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   ),

        // Selection mode indicator
        if (viewModel.isSelectingPickup || viewModel.isSelectingDestination)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    viewModel.isSelectingPickup
                        ? 'Select pickup location'
                        : 'Select destination',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

        // Custom My Location button
        Positioned(
          bottom: 100,
          right: 16,
          child: FloatingActionButton(
            heroTag: "myLocation",
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue[600],
            onPressed: () {
              if (viewModel.currentState.currentPosition != null) {
                _centerMapOnLocation(viewModel.currentState.currentPosition!);
              } else {
                viewModel.getCurrentLocationAndCenter();
              }
            },
            child: Icon(Icons.my_location),
          ),
        ),

        // Route fit button (only show when route is available)
        if (viewModel.currentState.routePolyline.isNotEmpty)
          Positioned(
            bottom: 160,
            right: 16,
            child: FloatingActionButton(
              heroTag: "fitRoute",
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.green[600],
              onPressed: () {
                _fitMapToRoute(viewModel.currentState.routePolyline);
              },
              child: Icon(Icons.fit_screen),
            ),
          ),

        // Debug button to test current location centering
        Positioned(
          bottom: 220,
          right: 16,
          child: FloatingActionButton(
            heroTag: "debugCenter",
            mini: true,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            onPressed: () {
              if (viewModel.currentState.currentPosition != null) {
                _handleInitialCentering(viewModel);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Centered on current location'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Current location not available'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Icon(Icons.center_focus_strong),
          ),
        ),

        // Debug button to manually trigger polyline calculation
        Positioned(
          bottom: 280,
          right: 16,
          child: FloatingActionButton(
            heroTag: "debugPolyline",
            mini: true,
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            onPressed: () async {
              if (viewModel.canUpdateLocation()) {
                await viewModel.calculateRoute();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Polyline calculation triggered'),
                    duration: Duration(seconds: 1),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Both pickup and destination required'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Icon(Icons.route),
          ),
        ),
      ],
    );
  }

  Set<Marker> _buildMarkers(PassengerModeViewModel viewModel) {
    final markers = <Marker>{};

    // Current location marker
    if (viewModel.currentState.currentPosition != null) {
      markers.add(Marker(
        markerId: MarkerId('current'),
        position: viewModel.currentState.currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        infoWindow: InfoWindow(title: 'Current Location'),
      ));
    }

    // Pickup location marker
    if (viewModel.currentState.pickupLocation != null) {
      markers.add(Marker(
        markerId: MarkerId('pickup'),
        position: viewModel.currentState.pickupLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Pickup Location'),
      ));
    }

    // Destination marker
    if (viewModel.currentState.destinationLocation != null) {
      markers.add(Marker(
        markerId: MarkerId('destination'),
        position: viewModel.currentState.destinationLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'Destination'),
      ));
    }

    return markers;
  }

  Set<Polyline> _buildPolylines(PassengerModeViewModel viewModel) {
    final polylines = <Polyline>{};

    // Add route polyline if available
    if (viewModel.currentState.routePolyline.isNotEmpty) {
      print("--------Building polyline with ${viewModel.currentState.routePolyline.length} points-----");
      polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: viewModel.currentState.routePolyline,
        color: Colors.blue,
        width: 4,
        geodesic: true,
      ));
    } else {
      print("--------No polyline points available-----");
    }

    return polylines;
  }

  void _centerMapOnLocation(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void _fitMapToRoute(List<LatLng> routePoints) {
    if (_mapController != null && routePoints.isNotEmpty) {
      double minLat = routePoints.first.latitude;
      double maxLat = routePoints.first.latitude;
      double minLng = routePoints.first.longitude;
      double maxLng = routePoints.first.longitude;

      for (final point in routePoints) {
        minLat = min(minLat, point.latitude);
        maxLat = max(maxLat, point.latitude);
        minLng = min(minLng, point.longitude);
        maxLng = max(maxLng, point.longitude);
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50.0),
      );
    }
  }

  Widget _buildRideDetails(
      BuildContext context, PassengerModeViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance: ${viewModel.currentState.distance}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Duration: ${viewModel.currentState.duration}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Estimated Fare: NPR ${viewModel.currentState.estimatedFare.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: viewModel.canBookRide
                    ? () => _bookRide(context, viewModel)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: viewModel.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Book Ride',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSelectionMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _bookRide(
      BuildContext context, PassengerModeViewModel viewModel) async {
    final success = await viewModel.bookRide();

    if (success) {
      _showBookingConfirmation(context, viewModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book ride. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

// confirmation for ride book
  Future<void> _showRideDetailsBottomSheet(
      BuildContext context, PassengerModeViewModel viewModel) async {
    final rideDetails = viewModel.rideDetails;
    viewModel.setHasShownBottomSheet(true);

    RideDetailsBottomSheet.show(
      context: context,
      distance: viewModel.distance,
      duration: viewModel.duration,
      estimatedFare: viewModel.estimatedFare,
      canBookRide: viewModel.canBookRide,
      isLoading: viewModel.isLoading,
      onBookRide: () => _bookRide(context, viewModel),
    );
  }

  void _showBookingConfirmation(
      BuildContext context, PassengerModeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ride Booked Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pickup: ${viewModel.currentState.pickupAddress}'),
              SizedBox(height: 8),
              Text('Destination: ${viewModel.currentState.destinationAddress}'),
              SizedBox(height: 8),
              Text('Distance: ${viewModel.currentState.distance}'),
              Text('Duration: ${viewModel.currentState.duration}'),
              Text(
                'Fare: NPR ${viewModel.currentState.estimatedFare.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
