class PasswordValidationResponse {
  final bool isValid;
  final String? message;
  final bool containsPersonalInfo;
  final bool banned;
  final bool previouslyUsed;

  PasswordValidationResponse({
    required this.isValid,
    required this.message,
    required this.containsPersonalInfo,
    required this.banned,
    required this.previouslyUsed,
  });

  factory PasswordValidationResponse.fromJson(Map<String, dynamic> json) {
    return PasswordValidationResponse(
      isValid: json['valid'],
      message: json['message'],
      containsPersonalInfo: json['containsPersonalInfo'] ?? false,
      banned: json['banned'] ?? false,
      previouslyUsed: json['previouslyUsed'] ?? false,
    );
  }
}
