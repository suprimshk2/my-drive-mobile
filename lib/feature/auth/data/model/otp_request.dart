class VerifyOtpRequestModel {
  String otpCode;
  String otpToken;
  VerifyOtpRequestModel({required this.otpCode, required this.otpToken});
  Map<String, dynamic> toJson() => {
        "otpCode": otpCode,
        "otpToken": otpToken,
      };
}
