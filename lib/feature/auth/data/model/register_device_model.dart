class RegisterDeviceModel {
  final String deviceId;
  final String fcmToken;

  RegisterDeviceModel({
    required this.deviceId,
    required this.fcmToken,
  });

  factory RegisterDeviceModel.fromJson(Map<String, dynamic> json) {
    return RegisterDeviceModel(
      deviceId: json['deviceId'] as String,
      fcmToken: json['fcmToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {  
      'deviceId': deviceId,
      'fcmToken': fcmToken,
    };
  }
}