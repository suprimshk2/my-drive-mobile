class BiometricSetupRequestModel {
  final String deviceId;

  BiometricSetupRequestModel({
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {"deviceId": deviceId};
}
