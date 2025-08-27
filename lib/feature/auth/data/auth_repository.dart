import 'package:mydrivenepal/feature/auth/data/model/apple_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/google_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/otp_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_payload.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/reset_password_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/set_password_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_response.dart';
import 'package:mydrivenepal/feature/feature.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> googleLogin(GoogleLoginRequest request);
  Future<LoginResponseModel> appleLogin(AppleLoginRequest request);
  Future<void> onBoard();
  Future<void> registerDevice();
  Future<bool> logout();
  Future<void> setAccessToken(String accessToken);
  Future<String> getAccessToken();
  Future<bool> getAgreedToTerms();
  Future<void> setAgreedToTerms();
  Future<bool> isBiometricSetup();
  Future<void> setupBiometric();
  Future<BiometricBaseModel> biometricLogin();
  Future<void> disableBiometricLogin();
  Future<void> setDealShowCase();
  Future<bool> getDealShowCase();
  Future<void> updateUserDevice();
  Future<LoginBaseModel> login(LoginRequestModel requestModel);
  Future<void> setRememberMe(bool value);
  Future<bool> getRememberMe();
  Future<String> getRememberMeData();
  Future<void> setRememberMeData(String value);
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
