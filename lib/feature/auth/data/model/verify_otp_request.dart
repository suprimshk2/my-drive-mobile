import 'package:mydrivenepal/shared/constant/constants.dart';

class VerifyOtpReq {
  final String? code;
  final String? phone;
  final String action;

  VerifyOtpReq({
    this.code,
    this.phone,
    this.action = ApiActions.SUBMIT,
  });

  factory VerifyOtpReq.fromJson(Map<String, dynamic> json) {
    return VerifyOtpReq(
      code: json['code'],
      phone: json['phone'],
      action: json['action'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'phone': phone,
      'action': action,
    };
  }
}
