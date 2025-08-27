class PasswordValidationPayload {
  final String? password;
  final bool? checkPreviousPassword;

  PasswordValidationPayload({
    required this.password,
    required this.checkPreviousPassword,
  });

  factory PasswordValidationPayload.fromJson(Map<String, dynamic> json) {
    return PasswordValidationPayload(
      password: json['password'],
      checkPreviousPassword: json['checkPreviousPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'checkPreviousPassword': checkPreviousPassword,
    };
  }
}
