import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/auth/data/auth_repository.dart';
import 'package:mydrivenepal/feature/home/data/model/app_version_model.dart';
import 'package:mydrivenepal/feature/profile/constants/profile_strings.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_data.dart';
import 'package:mydrivenepal/feature/profile/data/remote/profile_remote.dart';
import 'package:mydrivenepal/shared/util/custom_functions.dart';
import 'package:mydrivenepal/shared/util/response.dart';

class ProfileViewmodel extends ChangeNotifier {
  final ProfileRemote _profileRemote;
  final AuthRepository _authRepository;

  ProfileViewmodel({
    required ProfileRemote profileRemote,
    required AuthRepository authRepository,
  })  : _profileRemote = profileRemote,
        _authRepository = authRepository;

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

  Response<UserDataResponse> _userDataUseCase = Response<UserDataResponse>();

  Response<UserDataResponse> get userDataUseCase => _userDataUseCase;

  set userDataUseCase(Response<UserDataResponse> value) {
    _userDataUseCase = value;
    notifyListeners();
  }

  Future<void> getUserData() async {
    userDataUseCase = Response.loading();

    try {
      final userData = await _profileRemote.getUserData();
      userDataUseCase = Response.complete(userData);
    } catch (error) {
      userDataUseCase = Response.error(error);
    }
  }

  Response<bool> _logoutUseCase = Response<bool>();
  Response<bool> get logoutUseCase => _logoutUseCase;

  set logoutUseCase(Response<bool> response) {
    _logoutUseCase = response;
    notifyListeners();
  }

  Future<void> logout() async {
    logoutUseCase = Response.loading();
    try {
      var hasLoggedOut = await _authRepository.logout();
      if (hasLoggedOut) {
        logoutUseCase = Response.complete(true);
      } else {
        logoutUseCase = Response.error(
          Exception(ProfileStrings.logoutFailed),
        );
      }
    } catch (e) {
      logoutUseCase = Response.error(e);
    }
  }
}
