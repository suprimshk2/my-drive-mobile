class BiometricLoginRequestModel {
  final String deviceId;
  final int userId;
  final String challengeKey;

  BiometricLoginRequestModel({
    required this.deviceId,
    required this.userId,
    required this.challengeKey,
  });

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "userId": userId,
        "challengeKey": challengeKey,
      };
}
