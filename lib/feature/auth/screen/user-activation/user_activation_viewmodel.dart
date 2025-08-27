import 'package:mydrivenepal/feature/auth/data/model/reset_password_request_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/verify_code_response.dart';
import 'package:mydrivenepal/feature/feature.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:flutter/material.dart';

class UserActivationViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  UserActivationViewmodel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  Response<VerifyCodeResponse> _verifyCodeUseCase =
      Response<VerifyCodeResponse>();
  Response<VerifyCodeResponse> get verifyCodeUseCase => _verifyCodeUseCase;

  set verifyCodeUseCase(Response<VerifyCodeResponse> response) {
    _verifyCodeUseCase = response;
    notifyListeners();
  }

  Future<void> verifyCode({
    required String code,
  }) async {
    verifyCodeUseCase = Response.loading();

    try {
      final response = await _authRepository.verifyCodeForPasswordExpired(
        code: code,
      );

      verifyCodeUseCase = Response.complete(response);
    } catch (exception) {
      verifyCodeUseCase = Response.error(exception);
    }
  }

  Response<bool> _setPasswordForActivationUsecase = Response<bool>();
  Response<bool> get setPasswordForActivationUsecase =>
      _setPasswordForActivationUsecase;

  set setPasswordForActivationUsecase(Response<bool> response) {
    _setPasswordForActivationUsecase = response;
    notifyListeners();
  }

  Future<void> setPasswordForActivation({
    required String code,
    required String password,
    required String email,
    required int id,
  }) async {
    setPasswordForActivationUsecase = Response.loading();

    try {
      final response = await _authRepository.resetPassword(
        isActivatingUser: true,
        code: code,
        payload: ResetPasswordRequestModel(
          password: password,
          email: email,
          id: id,
        ),
      );

      setPasswordForActivationUsecase = Response.complete(response);
    } catch (exception) {
      setPasswordForActivationUsecase = Response.error(exception);
    }
  }
}
