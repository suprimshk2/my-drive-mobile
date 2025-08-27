class BiometricChallengeModel {
  final String nonce;
  final String challengeId;
  final int timestamp;

  BiometricChallengeModel({
    required this.nonce,
    required this.challengeId,
    required this.timestamp,
  });

  factory BiometricChallengeModel.fromJson(Map<String, dynamic> json) =>
      BiometricChallengeModel(
        nonce: json["nonce"],
        challengeId: json["challengeId"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "nonce": nonce,
        "challengeId": challengeId,
        "timestamp": timestamp,
      };
}
