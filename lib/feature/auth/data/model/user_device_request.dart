class UserDeviceRequestModel {
  final String deviceId;
  final String? platform;
  final String? notificationToken;

  UserDeviceRequestModel({
    required this.deviceId,
    this.platform,
    this.notificationToken,
  });

  factory UserDeviceRequestModel.fromJson(Map<String, dynamic> json) =>
      UserDeviceRequestModel(
        deviceId: json["deviceId"],
        platform: json["platform"],
        notificationToken: json["notificationToken"],
      );

  Map<String, dynamic> toJson() => {
        "deviceId": deviceId,
        "platform": platform,
        "notificationToken": notificationToken,
      };
}
