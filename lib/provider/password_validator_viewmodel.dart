import 'dart:async';

import 'package:mydrivenepal/feature/auth/auth.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_payload.dart';
import 'package:mydrivenepal/feature/auth/data/model/password_validation_response.dart';
import 'package:mydrivenepal/shared/util/reg_exp.dart';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/util/response.dart';

class PasswordValidatorViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  PasswordValidatorViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Timer? _debounce;

  String _uuId = "";

  String get uuId => _uuId;

  set uuId(String value) {
    _uuId = value;
  }

  String _password = "";

  String get password => _password;

  set password(String value) {
    _password = value;
    validatePassword();
  }

  String _confirmPassword = "";

  String get confirmPassword => _confirmPassword;

  set confirmPassword(String value) {
    _confirmPassword = value;
    validatePassword();
  }

  void validatePassword() async {
    // strong password check
    if (RexExpUtil.strongPassword.hasMatch(password)) {
      isPasswordStrong = true;

      // password match check
      if (_confirmPassword == _password) {
        isPasswordMatch = true;
      } else {
        isPasswordMatch = false;
      }

      // password validation from server
      _debounce = Timer(const Duration(milliseconds: 1000), () async {
        await validatePasswordFromServer();

        if (passwordValidationResponse.data?.isValid == true) {
          // success case.
          isPasswordValid = true;
          passwordHasPersonalInfo = false;
          passwordIsGloballyBanned = false;
          passwordIsUsed = false;
          return;
        } else {
          // error case.
          isPasswordValid = false;

          passwordIsGloballyBanned =
              passwordValidationResponse.data?.banned ?? false;
          passwordIsUsed =
              passwordValidationResponse.data?.previouslyUsed ?? false;
          passwordHasPersonalInfo =
              passwordValidationResponse.data?.containsPersonalInfo ?? false;
        }
      });
    } else {
      isPasswordValid = false;
      isPasswordStrong = false;
      // isPasswordMatch = false;

      // passwordHasPersonalInfo = true;
      // passwordIsGloballyBanned = true;
      // passwordIsUsed = true;

      if (_debounce?.isActive ?? false) _debounce!.cancel();
    }
  }

  // for state of button
  bool _isPasswordValid = false;

  bool get isPasswordValid => _isPasswordValid;

  set isPasswordValid(bool value) {
    _isPasswordValid = value;
    notifyListeners();
  }

  bool _isPasswordStrong = false;

  bool get isPasswordStrong => _isPasswordStrong;

  set isPasswordStrong(bool value) {
    _isPasswordStrong = value;
    notifyListeners();
  }

  bool _isPasswordMatch = false;

  bool get isPasswordMatch => _isPasswordMatch;

  set isPasswordMatch(bool value) {
    _isPasswordMatch = value;
    notifyListeners();
  }

  bool _passwordHasPersonalInfo = true;

  bool get passwordHasPersonalInfo => _passwordHasPersonalInfo;

  set passwordHasPersonalInfo(bool value) {
    _passwordHasPersonalInfo = value;
    notifyListeners();
  }

  bool _passwordIsGloballyBanned = true;

  bool get passwordIsGloballyBanned => _passwordIsGloballyBanned;

  set passwordIsGloballyBanned(bool value) {
    _passwordIsGloballyBanned = value;
    notifyListeners();
  }

  bool _passwordIsUsed = true;

  bool get passwordIsUsed => _passwordIsUsed;

  set passwordIsUsed(bool value) {
    _passwordIsUsed = value;
    notifyListeners();
  }

  Response<PasswordValidationResponse> _passwordValidationResponse =
      Response<PasswordValidationResponse>();

  Response<PasswordValidationResponse> get passwordValidationResponse =>
      _passwordValidationResponse;

  set passwordValidationResponse(
      Response<PasswordValidationResponse> response) {
    _passwordValidationResponse = response;
    notifyListeners();
  }

  Future<void> validatePasswordFromServer() async {
    passwordValidationResponse = Response.loading();

    try {
      final response = await _authRepository.validatePassword(
        uuId: uuId,
        payload: PasswordValidationPayload(
          password: password,
          checkPreviousPassword: true,
        ),
      );
      passwordValidationResponse = Response.complete(response);
    } catch (exception) {
      passwordValidationResponse = Response.error(exception);
    }
  }
}
