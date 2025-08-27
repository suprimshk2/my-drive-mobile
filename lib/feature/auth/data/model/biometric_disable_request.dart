class BiometricDisableRequestModel {
  final String deviceId;

  BiometricDisableRequestModel({
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {"deviceId": deviceId};
}
