import 'package:mydrivenepal/feature/auth/data/model/google_login_request.dart';

class AppleLoginRequest {
  String firstName;
  String lastName;
  String code;
  final DeviceNotificationModel deviceNotification;

  AppleLoginRequest({
    required this.firstName,
    required this.lastName,
    required this.code,
    required this.deviceNotification,
  });

  factory AppleLoginRequest.fromJson(Map<String, dynamic> json) =>
      AppleLoginRequest(
        firstName: json["firstName"],
        lastName: json["lastName"],
        code: json["code"],
        deviceNotification:
            DeviceNotificationModel.fromJson(json["deviceNotification"]),
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "code": code,
        "deviceToken": deviceNotification.toJson(),
      };
}
