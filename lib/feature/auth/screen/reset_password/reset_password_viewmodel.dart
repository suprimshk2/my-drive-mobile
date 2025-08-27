import 'package:mydrivenepal/feature/auth/data/auth_repository.dart';
import 'package:mydrivenepal/feature/auth/data/model/reset_password_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';

import 'package:mydrivenepal/shared/util/response.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ResetPasswordViewmodel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Response<VerifyCodeResponse> _verifyCodeUsecase =
      Response<VerifyCodeResponse>();
  Response<VerifyCodeResponse> get verifyCodeUsecase => _verifyCodeUsecase;

  set verifyCodeUsecase(Response<VerifyCodeResponse> response) {
    _verifyCodeUsecase = response;
    notifyListeners();
  }

  Future<void> verifyCode({
    required String code,
  }) async {
    verifyCodeUsecase = Response.loading();

    try {
      final response =
          await _authRepository.verifyCodeForPasswordExpired(code: code);
      verifyCodeUsecase = Response.complete(response);
    } catch (exception) {
      verifyCodeUsecase = Response.error(exception);
    }
  }

  Response<bool> _resetPasswordUseCase = Response<bool>();
  Response<bool> get resetPasswordUseCase => _resetPasswordUseCase;

  set resetPasswordUseCase(Response<bool> response) {
    _resetPasswordUseCase = response;
    notifyListeners();
  }

  Future<void> resetPassword({
    required String password,
    required String code,
  }) async {
    resetPasswordUseCase = Response.loading();

    try {
      var verifyCodeResponse = _verifyCodeUsecase.data;

      if (!verifyCodeUsecase.hasCompleted) {
        verifyCodeResponse =
            await _authRepository.verifyCodeForPasswordExpired(code: code);
      }

      final response = await _authRepository.resetPassword(
        code: code,
        payload: ResetPasswordRequestModel(
          password: password,
          email: verifyCodeResponse?.user?.email ?? '',
          id: verifyCodeResponse?.user?.userId?.toInt() ?? 0,
        ),
      );

      resetPasswordUseCase = Response.complete(response);
    } catch (exception) {
      resetPasswordUseCase = Response.error(exception);
    }
  }
}
