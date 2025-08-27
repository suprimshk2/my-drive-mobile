import 'package:mydrivenepal/feature/auth/data/model/user_mode_model.dart';

abstract class AuthLocal {
  Future<void> setAccessToken(String accessToken);
  Future<String> getAccessToken();
  Future<void> removeAccessToken();
  Future<void> setIsFirstTime(bool value);

  Future<void> removeBiometricData();

  Future<bool> hasBiometricData();
  Future<String> getBiometricKey();
  Future<void> setBiometricKey(String key);
  Future<String> getUserId();
  Future<void> setUserId(String value);
  Future<String> getMemberId();
  Future<void> setMemberId(String value);
  Future<void> removeMemberId();
  Future<bool> getAgreedToTerms();
  Future<void> setAgreedToTerms();
  Future<bool> getDisclaimerAck();
  Future<void> setDisclaimerAck();
  Future<void> removeDisclaimerAck();
  Future<bool> getDealShowCase();
  Future<void> setDealShowCase();
  Future<void> setBaseUrl(String url);
  Future<String> getBaseUrl();
  Future<bool> isRememberedMe();
  Future<void> setIsRememberedMe(bool value);
  Future<String> getRememberMeData();
  Future<void> setRememberMeData(String value);

  // User Mode Management
  Future<void> setUserMode(UserModeModel userMode);
  Future<UserModeModel?> getUserMode();
  Future<void> setCurrentMode(UserMode mode);
  Future<UserMode> getCurrentMode();
  Future<void> setAvailableModes(List<UserMode> modes);
  Future<List<UserMode>> getAvailableModes();
}
