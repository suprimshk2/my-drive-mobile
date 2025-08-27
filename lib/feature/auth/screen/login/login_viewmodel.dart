import 'package:mydrivenepal/feature/auth/data/model/apple_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/google_login_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_base_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';
import 'package:mydrivenepal/feature/user-mode/user_mode.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/auth/data/model/otp_response.dart';
import 'package:mydrivenepal/feature/communications/utils/comet_chat_init.dart';
import 'package:mydrivenepal/feature/feature.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/di/service_locator.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final CometChatInit _cometChatInit;

  LoginViewModel({
    required AuthRepository authRepository,
    required CometChatInit cometChatInit,
  })  : _authRepository = authRepository,
        _cometChatInit = cometChatInit;

  Response<LoginResponseModel> _verifyOtpUseCase =
      Response<LoginResponseModel>();
  String _otpToken = "";
  bool _canResendCode = false;
  DateTime _resendCooldownEndDate = DateTime.now();
  bool _needOtpVerification = false;
  Response<LoginResponseModel> get verifyOtpUseCase => _verifyOtpUseCase;
  bool get canResendCode => _canResendCode;
  DateTime get resendCooldownEndDate => _resendCooldownEndDate;
  bool get needOtpVerification => _needOtpVerification;

  Response<LoginResponseModel> _googleLoginUseCase =
      Response<LoginResponseModel>();
  Response<LoginResponseModel> get googleLoginUseCase => _googleLoginUseCase;
  set googleLoginUseCase(Response<LoginResponseModel> response) {
    _googleLoginUseCase = response;
    notifyListeners();
  }

  Response<LoginResponseModel> _appleLoginUseCase =
      Response<LoginResponseModel>();
  Response<LoginResponseModel> get appleLoginUseCase => _appleLoginUseCase;
  set appleLoginUseCase(Response<LoginResponseModel> response) {
    _appleLoginUseCase = response;
    notifyListeners();
  }

  Future<void> googleLogin(String accessToken) async {
    googleLoginUseCase = Response.loading();
    try {
      final String notificationToken =
          await NotificationHelper().requestToken();
      NotificationHelper().refreshToken();
      final deviceInfo = await DeviceInfoHelper.getDeviceInfo();

      final request = GoogleLoginRequest(
        token: accessToken,
        deviceNotification: DeviceNotificationModel(
          deviceId: deviceInfo.deviceId,
          notificationToken: notificationToken,
          platform: PlatformHelper.platform.name,
        ),
      );

      debugPrint('google login: ${request.toJson()}');

      final response = await _authRepository.googleLogin(request);

      googleLoginUseCase = Response.complete(response);
    } catch (exp) {
      googleLoginUseCase = Response.error(exp);
    }
  }

  Future<void> appleLogin(AppleLoginRequest request) async {
    appleLoginUseCase = Response.loading();
    print("request-->${request.toJson()}");
    try {
      final response = await _authRepository.appleLogin(request);
      appleLoginUseCase = Response.complete(response);
    } catch (exp) {
      appleLoginUseCase = Response.error(exp);
    }
  }

  void _setResendCooldownEndDate(double resendCoolDownInMinutes) {
    _resendCooldownEndDate = DateTime.now().add(
      Duration(
        milliseconds: (resendCoolDownInMinutes * 60 * 1000).toInt(),
      ),
    );
  }

  void allowResendCode() {
    _canResendCode = true;
    notifyListeners();
  }

  void setVerifyOtpUseCase(Response<LoginResponseModel> response) {
    _verifyOtpUseCase = response;
    notifyListeners();
  }

  void setNeedOtpVerification(bool value) {
    _needOtpVerification = value;
  }

  Future<void> updateUserDevice() async {
    _authRepository.updateUserDevice();
  }

  Response<LoginBaseModel> _loginUseCase = Response<LoginBaseModel>();
  Response<LoginBaseModel> get loginUseCase => _loginUseCase;
  set loginUseCase(Response<LoginBaseModel> response) {
    _loginUseCase = response;
    notifyListeners();
  }

  bool _isRememberMe = false;
  String _rememberMeData = "";
  bool get isRememberMe => _isRememberMe;
  String get rememberMeData => _rememberMeData;
  Future<void> getRememberDetails() async {
    _rememberMeData = await _authRepository.getRememberMeData();
    _isRememberMe = await _authRepository.getRememberMe();
    notifyListeners();
  }

  void setRememberMeData(String value) async {
    await _authRepository.setRememberMeData(value);
    notifyListeners();
  }

  void setRememberMe(bool value) async {
    _isRememberMe = value;
    notifyListeners();
  }

  Future<void> login(LoginRequestModel requestModel) async {
    loginUseCase = Response.loading();
    try {
      final response = await _authRepository.login(requestModel);

      _authRepository.setRememberMe(isRememberMe);
      if (isRememberMe) {
        _authRepository.setRememberMeData(requestModel.userName);
      } else {
        _authRepository.setRememberMeData("");
      }

      if (response.isSuccess) {
        _cometChatInit.login(response.successData?.user?.id.toString() ?? "");
        await _authRepository.registerDevice();

        // Initialize user mode after successful login
        await _initializeUserMode(response.successData?.user?.roles);
      }
      loginUseCase = Response.complete(response);
    } catch (exp) {
      loginUseCase = Response.error(exp);
      _authRepository.setRememberMe(false);
      _authRepository.setRememberMeData("");
    }
  }

  // Initialize user mode based on user roles
  Future<void> _initializeUserMode(List<RoleModel>? userRoles) async {
    try {
      final userModeViewModel = locator<UserModeViewModel>();
      await userModeViewModel.initializeUserMode(userRoles);
    } catch (e) {
      // Log error but don't fail login
      print('Failed to initialize user mode: $e');
    }
  }

  Response<AppVersionModel> _appVersion = Response<AppVersionModel>();
  Response<AppVersionModel> get appVersion => _appVersion;

  set appVersion(Response<AppVersionModel> value) {
    _appVersion = value;
    notifyListeners();
  }

  Future<void> getVersion() async {
    appVersion = Response.loading();
    try {
      final appVersion = await getAppVersion();
      this.appVersion = Response.complete(appVersion);
    } catch (error) {
      appVersion = Response.error(error);
    }
  }
}
