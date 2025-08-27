import 'package:mydrivenepal/feature/auth/data/model/apple_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_disable_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_setup_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/google_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_request_model.dart';
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
import 'package:mydrivenepal/feature/communications/utils/comet_chat_init.dart';
import 'package:mydrivenepal/feature/feature.dart';
import 'package:mydrivenepal/shared/shared.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocal _authLocal;
  final AuthRemote _authRemote;
  final CometChatInit _cometChatRepo;

  AuthRepositoryImpl(
      {required AuthLocal authLocal,
      required AuthRemote authRemote,
      required CometChatInit cometChatRepo})
      : _authLocal = authLocal,
        _authRemote = authRemote,
        _cometChatRepo = cometChatRepo;

  @override
  Future<LoginResponseModel> googleLogin(GoogleLoginRequest request) async {
    final response = await _authRemote.googleLogin(request);
    // await _authLocal.setUserData(response.user.userData);
    await _authLocal.setUserId(response.user.id ?? "");
    await _authLocal.setAccessToken(response.accessToken);
    return response;
  }

  @override
  Future<LoginResponseModel> appleLogin(AppleLoginRequest request) async {
    final response = await _authRemote.appleLogin(request);
    // await _authLocal.setUserData(response.user.userData);
    await _authLocal.setAccessToken(response.accessToken);
    return response;
  }

  @override
  Future<void> onBoard() async {
    await _authLocal.setIsFirstTime(false);
  }

  @override
  Future<void> updateUserDevice() async {
    try {
      final String token = await NotificationHelper().requestToken();
      final deviceInfo = await DeviceInfoHelper.getDeviceInfo();
      final UserDeviceRequestModel payload = UserDeviceRequestModel(
        deviceId: deviceInfo.deviceId,
        platform: PlatformHelper.platform.name,
        notificationToken: token,
      );
      _authRemote.updateUserDevice(payload);
    } catch (e) {}
  }

  @override
  Future<bool> logout() async {
    final userId = await _authLocal.getUserId();
    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();
    // var hasLoggedOut = await _authRemote.logout(
    //   userId: userId.toString(),
    //   payload: LogoutPayload(deviceId: deviceInfo.deviceId),
    // );
    // if (hasLoggedOut) {
    await _authLocal.removeAccessToken();
    await _authLocal.removeMemberId();
    await _authLocal.removeDisclaimerAck();
    await _cometChatRepo.logout();
    // }

    return true;
  }

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _authLocal.setAccessToken(accessToken);
  }

  @override
  Future<String> getAccessToken() async {
    return await _authLocal.getAccessToken();
  }

  @override
  Future<bool> getAgreedToTerms() async {
    return await _authLocal.getAgreedToTerms();
  }

  @override
  Future<void> setAgreedToTerms() async {
    await _authLocal.setAgreedToTerms();
  }

  @override
  Future<bool> isBiometricSetup() async {
    return await _authLocal.hasBiometricData();
  }

  @override
  Future<void> setupBiometric() async {
    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();
    final biometricSetupRequest =
        BiometricSetupRequestModel(deviceId: deviceInfo.deviceId);

    final biometricSetupResponse =
        await _authRemote.setupBiometric(biometricSetupRequest);
    if (isNotEmpty(biometricSetupResponse.challengeKey)) {
      _authLocal.setBiometricKey(biometricSetupResponse.challengeKey);
    }
  }

  @override
  Future<BiometricBaseModel> biometricLogin() async {
    if (!(await isBiometricSetup())) {
      throw Exception("Biometric has not been setup.");
    }
    final String challengeKey = await _authLocal.getBiometricKey();
    final String userId = await _authLocal.getUserId();
    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();

    final biometricLoginResponse = await _authRemote.biometricLogin(
      BiometricLoginRequestModel(
        deviceId: deviceInfo.deviceId,
        userId: int.parse(userId),
        challengeKey: challengeKey,
      ),
    );
    if (biometricLoginResponse.isSuccess) {
      final biometricSuccessResponse = biometricLoginResponse.successData;
      await _authLocal
          .setMemberId(biometricSuccessResponse?.user?.memberUuid ?? '');
      if (biometricSuccessResponse?.user?.userSetting?.disclaimerAck ?? false) {
        await _authLocal.setDisclaimerAck();
      }

      setAccessToken(biometricSuccessResponse?.token ?? '');
      await _authLocal
          .setBiometricKey(biometricSuccessResponse?.challengeKey ?? '');
    }

    return biometricLoginResponse;
  }

  @override
  Future<void> disableBiometricLogin() async {
    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();

    await _authRemote.disableBiometricLogin(
        BiometricDisableRequestModel(deviceId: deviceInfo.deviceId));
    _authLocal.removeBiometricData();
  }

  @override
  Future<bool> getDealShowCase() async {
    return _authLocal.getDealShowCase();
  }

  @override
  Future<void> setDealShowCase() async {
    _authLocal.setDealShowCase();
  }

  @override
  Future<LoginBaseModel> login(LoginRequestModel requestModel) async {
    final response = await _authRemote.login(requestModel);

    if (response.isSuccess) {
      setAccessToken(response.successData?.token ?? '');

      String previouslyLoggedInUserrId = await _authLocal.getUserId();

      int currentUserId = response.successData?.user?.id ?? 0;

      if (previouslyLoggedInUserrId != currentUserId) {
        await _authLocal.removeBiometricData();
      }

      await _authLocal.setUserId(response.successData?.user?.id.toString() ??
          ""); // todo: changed due to holista api issue.
      await _authLocal
          .setMemberId(response.successData?.user?.memberUuid ?? '');
      if (response.successData?.user?.userSetting?.disclaimerAck == true) {
        await _authLocal.setDisclaimerAck();
      }
    }

    return response;
  }

  @override
  Future<SendOtpResponse> sendOtpForForgotPassword({
    required String phoneNumber,
  }) {
    final sendOtpResponse = _authRemote.sendOtpForForgotPassword(
      phoneNumber: phoneNumber,
    );

    return sendOtpResponse;
  }

  @override
  Future<VerifyOtpResponse> verifyOtpForForgotPassword({
    required VerifyOtpReq payload,
  }) {
    final verifyOtpResponse = _authRemote.verifyOtpForForgotPassword(
      payload: payload,
    );

    return verifyOtpResponse;
  }

  @override
  Future<VerifyCodeResponse> verifyCodeForPasswordExpired(
      {required String code}) {
    final verifyCodeResponse =
        _authRemote.verifyCodeForPasswordExpired(code: code);

    return verifyCodeResponse;
  }

  @override
  Future<bool> resetPassword({
    required ResetPasswordRequestModel payload,
    required String code,
    bool isActivatingUser = false,
  }) {
    return _authRemote.resetPassword(
      payload: payload,
      code: code,
      isActivatingUser: isActivatingUser,
    );
  }

  @override
  Future<bool> setPasswordForForgotPassword({
    required SetPasswordPayload payload,
  }) {
    final setPasswordResponse =
        _authRemote.setPasswordForForgotPassword(payload: payload);

    return setPasswordResponse;
  }

  @override
  Future<PasswordValidationResponse> validatePassword({
    required String uuId,
    required PasswordValidationPayload payload,
  }) {
    final validatePasswordResponse = _authRemote.validatePassword(
      uuId: uuId,
      payload: payload,
    );

    return validatePasswordResponse;
  }

  @override
  Future<void> setRememberMe(bool value) async {
    await _authLocal.setIsRememberedMe(value);
  }

  @override
  Future<bool> getRememberMe() async {
    return await _authLocal.isRememberedMe();
  }

  @override
  Future<void> setRememberMeData(String value) async {
    await _authLocal.setRememberMeData(value);
  }

  @override
  Future<String> getRememberMeData() async {
    return await _authLocal.getRememberMeData();
  }

  @override
  Future<void> registerDevice() async {
    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();
    final String fcmToken = await NotificationHelper().requestToken();
    await _authRemote.registerDevice(RegisterDeviceModel(
      deviceId: deviceInfo.deviceId,
      fcmToken: fcmToken,
    ));
  }
}
