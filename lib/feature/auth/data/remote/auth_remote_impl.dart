import 'package:mydrivenepal/data/model/optional_headers.dart';
import 'package:mydrivenepal/feature/auth/data/model/apple_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_challenge.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_challenge_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_disable_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_login_reponse.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_setup_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_setup_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/google_login_request.dart'
    show GoogleLoginRequest;
import 'package:mydrivenepal/feature/auth/data/model/login_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_request_model.dart';
import 'package:mydrivenepal/data/data.dart';
import 'package:mydrivenepal/feature/auth/data/model/logout_payload.dart';
import 'package:mydrivenepal/feature/auth/data/model/otp_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_payload.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/register_device_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/reset_password_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/set_password_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/user_device_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_response.dart';
import 'package:mydrivenepal/feature/feature.dart';

import '../../../../shared/constant/remote_api_constant.dart';

class AuthRemoteImpl implements AuthRemote {
  final ApiClient _apiClient;

  AuthRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<LoginResponseModel> googleLogin(GoogleLoginRequest request) async {
    String url = RemoteAPIConstant.GOOGLE_LOGIN;
    final response = await _apiClient.post(url, request.toJson());
    final googleResponse = LoginResponseModel.fromJson(response.data);
    return googleResponse;
  }

  @override
  Future<LoginResponseModel> appleLogin(AppleLoginRequest request) async {
    String url = RemoteAPIConstant.APPLE_LOGIN;
    final response = await _apiClient.post(url, request.toJson());
    final appleResponse = LoginResponseModel.fromJson(response.data);
    return appleResponse;
  }

  @override
  Future<BiometricSetupResponseModel> setupBiometric(
      BiometricSetupRequestModel request) async {
    final apiResponse = await _apiClient.post(
        RemoteAPIConstant.BIOMETRIC_SETUP, request.toJson());
    return BiometricSetupResponseModel.fromJson(apiResponse.data);
  }

  @override
  Future<BiometricChallengeModel> createBiometricChallenge(
      BiometricChallengeRequestModel request) async {
    final apiResponse = await _apiClient.post(
        RemoteAPIConstant.BIOMETRIC_CREATE_CHALLENGE, request.toJson());
    return BiometricChallengeModel.fromJson(apiResponse.data);
  }

  @override
  Future<BiometricBaseModel> biometricLogin(
      BiometricLoginRequestModel request) async {
    final apiResponse = await _apiClient.post(
        RemoteAPIConstant.BIOMETRIC_LOGIN, request.toJson());
    return BiometricBaseModel.fromJson(apiResponse.data);
  }

  @override
  Future<void> disableBiometricLogin(
      BiometricDisableRequestModel request) async {
    await _apiClient.post(
      RemoteAPIConstant.BIOMETRIC_REMOVE,
      request.toJson(),
    );
  }

  @override
  Future<void> updateUserDevice(UserDeviceRequestModel request) async {
    await _apiClient.post(
      RemoteAPIConstant.UPDATE_DEVICE,
      request.toJson(),
    );
  }

  @override
  Future<bool> logout({
    required String userId,
    required LogoutPayload payload,
  }) async {
    var response = await _apiClient.post(
      RemoteAPIConstant.LOGOUT.replaceAll(':userId', userId),
      payload.toJson(),
    );

    if (response.data != null) {
      return true;
    }
    return false;
  }

  @override
  Future<LoginBaseModel> login(LoginRequestModel requestModel) async {
    String url = RemoteAPIConstant.LOGIN;
    final response = await _apiClient.post(url, requestModel.toJson());
    return LoginBaseModel.fromJson(response.data);
  }

  @override
  Future<SendOtpResponse> sendOtpForForgotPassword({
    required String phoneNumber,
  }) async {
    String path = RemoteAPIConstant.SEND_OTP_FOR_FORGOT_PASSWORD
        .replaceAll(':phoneNumber', phoneNumber);

    final response = await _apiClient.get(path);

    return SendOtpResponse.fromJson(response.data);
  }

  @override
  Future<VerifyOtpResponse> verifyOtpForForgotPassword({
    required VerifyOtpReq payload,
  }) async {
    final response = await _apiClient.post(
      RemoteAPIConstant.VERIFY_OTP_FOR_FORGOT_PASSWORD,
      payload.toJson(),
    );

    return VerifyOtpResponse.fromJson(response.data);
  }

  @override
  Future<VerifyCodeResponse> verifyCodeForPasswordExpired(
      {required String code}) async {
    String path = RemoteAPIConstant.VERIFY_CODE_FOR_PASSWORD_EXPIRED;

    final payload = <String, dynamic>{'code': code};

    final response = await _apiClient.post(path, payload);

    return VerifyCodeResponse.fromJson(response.data);
  }

  @override
  Future<bool> resetPassword({
    required ResetPasswordRequestModel payload,
    required String code,
    bool isActivatingUser = false,
  }) async {
    String path = isActivatingUser
        ? RemoteAPIConstant.SET_PASSWORD
        : RemoteAPIConstant.RESET_PASSWORD;

    final response = await _apiClient.post(
      path,
      payload.toJson(),
      headers: AdditionalHeaders(code: code),
    );

    return response.data;
  }

  @override
  Future<bool> setPasswordForForgotPassword({
    required SetPasswordPayload payload,
  }) async {
    final response = await _apiClient.post(
      RemoteAPIConstant.SET_PASSWORD,
      payload.toJson(),
    );

    return response.data;
  }

  @override
  Future<PasswordValidationResponse> validatePassword({
    required String uuId,
    required PasswordValidationPayload payload,
  }) async {
    String path = RemoteAPIConstant.VALIDATE_PASSWORD.replaceAll(':uuId', uuId);

    final response = await _apiClient.post(path, payload.toJson());

    return PasswordValidationResponse.fromJson(response.data);
  }

  @override
  Future<void> registerDevice(RegisterDeviceModel requestModel) async {
    await _apiClient.post(
      RemoteAPIConstant.REGISTER_DEVICE,
      requestModel.toJson(),
    );
  }
}
