class SendOtpRequestModel {
  String mobileNumber;

  SendOtpRequestModel({
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() => {
        "mobileNumber": mobileNumber,
      };
}
