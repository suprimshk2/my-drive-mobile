import 'dart:convert';

SendOtpResponse sendOtpResponseFromJson(String str) => SendOtpResponse.fromJson(json.decode(str));

String sendOtpResponseToJson(SendOtpResponse data) => json.encode(data.toJson());

class SendOtpResponse {
    final String? message;

    SendOtpResponse({
        this.message,
    });

    factory SendOtpResponse.fromJson(Map<String, dynamic> json) => SendOtpResponse(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
