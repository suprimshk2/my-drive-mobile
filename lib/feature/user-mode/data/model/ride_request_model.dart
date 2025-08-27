class RideRequestModel {
  final String pickupAddress;
  final String destinationAddress;
  final String distance;
  final String duration;
  final double fare;
  final DateTime requestTime;

  const RideRequestModel({
    required this.pickupAddress,
    required this.destinationAddress,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.requestTime,
  });

  Map<String, dynamic> toJson() => {
        'pickupAddress': pickupAddress,
        'destinationAddress': destinationAddress,
        'distance': distance,
        'duration': duration,
        'fare': fare,
        'requestTime': requestTime.toIso8601String(),
      };

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      pickupAddress: json['pickupAddress'] ?? '',
      destinationAddress: json['destinationAddress'] ?? '',
      distance: json['distance'] ?? '',
      duration: json['duration'] ?? '',
      fare: (json['fare'] ?? 0.0).toDouble(),
      requestTime: DateTime.parse(
          json['requestTime'] ?? DateTime.now().toIso8601String()),
    );
  }
}
