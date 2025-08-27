import 'dart:convert';

SetPasswordPayload setPasswordPayloadFromJson(String str) =>
    SetPasswordPayload.fromJson(json.decode(str));

String setPasswordPayloadToJson(SetPasswordPayload data) =>
    json.encode(data.toJson());

class SetPasswordPayload {
  final bool isMobile;
  final String password;
  final String phone;

  SetPasswordPayload({
    required this.phone,
    required this.password,
    this.isMobile = true,
  });

  factory SetPasswordPayload.fromJson(Map<String, dynamic> json) =>
      SetPasswordPayload(
        isMobile: json["isMobile"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "isMobile": isMobile,
        "password": password,
        "phone": phone,
      };
}
