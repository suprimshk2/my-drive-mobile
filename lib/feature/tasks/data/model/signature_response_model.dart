class SignatureResponseModel {
  String? envelopeId;
  String envelopeUrl;

  SignatureResponseModel({
    this.envelopeId,
    required this.envelopeUrl,
  });

  factory SignatureResponseModel.fromJson(Map<String, dynamic> json) {
    return SignatureResponseModel(
      envelopeId: json['envelopeId'],
      envelopeUrl: json['envelopeUrl'],
    );
  }
}
