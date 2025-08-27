class BiometricChallengeRequestModel {
  final String deviceId;
  final String userId;

  BiometricChallengeRequestModel({
    required this.deviceId,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "userId": userId,
      };
}