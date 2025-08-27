import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';

class BiometricLoginResponseModel extends LoginSuccessModel {
  final String challengeKey;

  BiometricLoginResponseModel({
    required this.challengeKey,
    super.user,
    super.token,
    super.isOtpLogin,
    super.isMfaEnabled,
    super.refreshToken,
  });

  factory BiometricLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return BiometricLoginResponseModel(
      challengeKey: json['challengeKey'] as String,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'] as String?,
      isOtpLogin: json['isOtpLogin'] as bool?,
      isMfaEnabled: json['isMfaEnabled'] as bool?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'challengeKey': challengeKey,
      };
}
