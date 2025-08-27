import 'package:mydrivenepal/feature/auth/data/model/apple_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_challenge.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_challenge_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_disable_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_login_reponse.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_setup_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_setup_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/google_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/logout_payload.dart';
import 'package:mydrivenepal/feature/auth/data/model/otp_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_payload.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/reset_password_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/set_password_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/user_device_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_response.dart';
import 'package:mydrivenepal/feature/feature.dart';

import '../model/register_device_model.dart';

abstract class AuthRemote {
  Future<LoginResponseModel> googleLogin(GoogleLoginRequest request);
  Future<LoginResponseModel> appleLogin(AppleLoginRequest request);
  Future<BiometricSetupResponseModel> setupBiometric(
      BiometricSetupRequestModel request);
  Future<BiometricChallengeModel> createBiometricChallenge(
      BiometricChallengeRequestModel request);
  Future<BiometricBaseModel> biometricLogin(BiometricLoginRequestModel request);
  Future<void> disableBiometricLogin(BiometricDisableRequestModel request);
  Future<void> updateUserDevice(UserDeviceRequestModel request);

  Future<bool> logout({
    required String userId,
    required LogoutPayload payload,
  });

  Future<LoginBaseModel> login(LoginRequestModel requestModel);
  Future<void> registerDevice(RegisterDeviceModel requestModel);

  Future<SendOtpResponse> sendOtpForForgotPassword({
    required String phoneNumber,
  });

  Future<VerifyOtpResponse> verifyOtpForForgotPassword({
    required VerifyOtpReq payload,
  });
  Future<VerifyCodeResponse> verifyCodeForPasswordExpired({
    required String code,
  });
  Future<bool> resetPassword({
    required ResetPasswordRequestModel payload,
    required String code,
    bool isActivatingUser = false,
  });

  Future<bool> setPasswordForForgotPassword({
    required SetPasswordPayload payload,
  });

  Future<PasswordValidationResponse> validatePassword({
    required String uuId,
    required PasswordValidationPayload payload,
  });
}
