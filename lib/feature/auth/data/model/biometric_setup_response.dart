import 'package:mydrivenepal/shared/shared.dart';

class BiometricSetupResponseModel implements JsonSerializable {
  final String challengeKey;

  BiometricSetupResponseModel({
    required this.challengeKey,
  });

  factory BiometricSetupResponseModel.fromJson(Map<String, dynamic> json) =>
      BiometricSetupResponseModel(
        challengeKey: json["challengeKey"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "challengeKey": challengeKey,
      };
}
