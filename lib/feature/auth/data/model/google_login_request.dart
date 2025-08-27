class GoogleLoginRequest {
  String token;
  final DeviceNotificationModel? deviceNotification;

  GoogleLoginRequest({
    required this.token,
    this.deviceNotification,
  });

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      GoogleLoginRequest(
        token: json["token"],
        deviceNotification:
            DeviceNotificationModel.fromJson(json["deviceNotification"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "deviceNotification": deviceNotification?.toJson(),
      };
}

class DeviceNotificationModel {
  final String deviceId;
  final String notificationToken;
  final String platform;

  DeviceNotificationModel({
    required this.deviceId,
    required this.notificationToken,
    required this.platform,
  });

  factory DeviceNotificationModel.fromJson(Map<String, dynamic> json) =>
      DeviceNotificationModel(
        deviceId: json["deviceId"],
        notificationToken: json["notificationToken"],
        platform: json["platform"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "notificationToken": notificationToken,
        "platform": platform,
      };
}
