import 'package:mydrivenepal/feature/auth/auth.dart';
import 'package:mydrivenepal/feature/auth/data/model/set_password_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_request.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_otp_response.dart';
import 'package:mydrivenepal/shared/util/response.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

class ForgotPasswordViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ForgotPasswordViewmodel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Response<SendOtpResponse> _requestOtpUseCase = Response<SendOtpResponse>();
  Response<SendOtpResponse> get requestOtpUseCase => _requestOtpUseCase;

  set requestOtpUseCase(Response<SendOtpResponse> response) {
    _requestOtpUseCase = response;
    notifyListeners();
  }

  Future<void> requestOtp(String phoneNumber) async {
    requestOtpUseCase = Response.loading();

    try {
      final response = await _authRepository.sendOtpForForgotPassword(
          phoneNumber: phoneNumber);

      requestOtpUseCase = Response.complete(response);
    } catch (exception) {
      requestOtpUseCase = Response.error(exception);
    }
  }

  Response<VerifyOtpResponse> _verifyOtpUseCase = Response<VerifyOtpResponse>();
  Response<VerifyOtpResponse> get verifyOtpUseCase => _verifyOtpUseCase;

  set verifyOtpUseCase(Response<VerifyOtpResponse> response) {
    _verifyOtpUseCase = response;
    notifyListeners();
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    verifyOtpUseCase = Response.loading();

    try {
      final response = await _authRepository.verifyOtpForForgotPassword(
        payload: VerifyOtpReq(
          phone: phoneNumber,
          code: otp,
        ),
      );

      verifyOtpUseCase = Response.complete(response);
    } catch (exception) {
      verifyOtpUseCase = Response.error(exception);
    }
  }

  Response<bool> _setPasswordUseCase = Response<bool>();
  Response<bool> get setPasswordUseCase => _setPasswordUseCase;

  set setPasswordUseCase(Response<bool> response) {
    _setPasswordUseCase = response;
    notifyListeners();
  }

  Future<void> setPassword({
    required String password,
    required String phoneNumber,
  }) async {
    setPasswordUseCase = Response.loading();

    try {
      final response = await _authRepository.setPasswordForForgotPassword(
        payload: SetPasswordPayload(
          phone: phoneNumber,
          password: password,
        ),
      );

      setPasswordUseCase = Response.complete(response);
    } catch (exception) {
      setPasswordUseCase = Response.error(exception);
    }
  }
}
