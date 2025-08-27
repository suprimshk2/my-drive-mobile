import 'package:mydrivenepal/feature/feature.dart';
import 'package:mydrivenepal/data/local/local.dart';
import 'package:mydrivenepal/feature/auth/data/model/user_mode_model.dart';

class AuthLocalImpl implements AuthLocal {
  final LocalStorageClient _sharedPrefManager;
  // final LocalStorageClient _secureStorageManager;

  AuthLocalImpl({
    required LocalStorageClient sharedPrefManager,
  }) : _sharedPrefManager = sharedPrefManager;
  // _secureStorageManager = secureStorageManager;

  @override
  Future<void> setAccessToken(String accessToken) async {
    await _sharedPrefManager.setString(
        LocalStorageKeys.ACCESS_TOKEN, accessToken);
  }

  @override
  Future<String> getAccessToken() async {
    final token =
        await _sharedPrefManager.getString(LocalStorageKeys.ACCESS_TOKEN);
    return token ?? '';
  }

  @override
  Future<void> setIsFirstTime(bool value) async {
    await _sharedPrefManager.setBool(LocalStorageKeys.IS_FIRST_TIME, value);
  }

  @override
  Future<void> removeAccessToken() async {
    await _sharedPrefManager.remove(LocalStorageKeys.ACCESS_TOKEN);
  }

  @override
  Future<void> removeMemberId() async {
    await _sharedPrefManager.remove(LocalStorageKeys.MEMBER_ID);
  }

  @override
  Future<String> getUserId() async {
    final String userId =
        await _sharedPrefManager.getString(LocalStorageKeys.USER_ID) ?? "";

    // if (userId == null) {
    //   throw Exception("User id is null"); //TODO: Error handling
    // }

    return userId;
  }

  @override
  Future<void> setUserId(String value) async {
    await _sharedPrefManager.setString(LocalStorageKeys.USER_ID, value);
  }

  @override
  Future<void> setMemberId(String value) async {
    await _sharedPrefManager.setString(LocalStorageKeys.MEMBER_ID, value);
  }

  @override
  Future<bool> getAgreedToTerms() async {
    return await _sharedPrefManager.getBool(LocalStorageKeys.TERMS_CONDITION) ??
        false;
  }

  @override
  Future<void> setAgreedToTerms() async {
    await _sharedPrefManager.setBool(LocalStorageKeys.TERMS_CONDITION, true);
  }

  @override
  Future<bool> hasBiometricData() async {
    return await _sharedPrefManager.containsKey(LocalStorageKeys.BIOMETRIC_KEY);
  }

  @override
  Future<void> removeBiometricData() async {
    await _sharedPrefManager.remove(LocalStorageKeys.BIOMETRIC_KEY);
  }

  @override
  Future<bool> getDisclaimerAck() async {
    try {
      final bool response =
          await _sharedPrefManager.getBool(LocalStorageKeys.DISCLAIMER_ACK) ??
              false;

      return response;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setDisclaimerAck() async {
    await _sharedPrefManager.setBool(LocalStorageKeys.DISCLAIMER_ACK, true);
  }

  @override
  Future<void> removeDisclaimerAck() async {
    await _sharedPrefManager.remove(LocalStorageKeys.DISCLAIMER_ACK);
  }

  @override
  Future<bool> getDealShowCase() async {
    try {
      final bool response =
          await _sharedPrefManager.getBool(LocalStorageKeys.DEAL_SHOW_CASE) ??
              false;

      return response;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> setDealShowCase() async {
    await _sharedPrefManager.setBool(LocalStorageKeys.DEAL_SHOW_CASE, true);
  }

  @override
  Future<void> setBaseUrl(String url) async {
    await _sharedPrefManager.setString(LocalStorageKeys.BASE_URL, url);
  }

  @override
  Future<String> getBaseUrl() async {
    String base_url =
        await _sharedPrefManager.getString(LocalStorageKeys.BASE_URL) ?? '';
    return base_url;
  }

  @override
  Future<String> getBiometricKey() async {
    String key =
        await _sharedPrefManager.getString(LocalStorageKeys.BIOMETRIC_KEY) ??
            '';
    return key;
  }

  @override
  Future<void> setBiometricKey(String key) async {
    await _sharedPrefManager.setString(LocalStorageKeys.BIOMETRIC_KEY, key);
  }

  @override
  Future<void> setIsRememberedMe(bool value) async {
    await _sharedPrefManager.setBool(LocalStorageKeys.IS_REMEMBERED_ME, value);
  }

  @override
  Future<void> setRememberMeData(String value) async {
    await _sharedPrefManager.setString(
        LocalStorageKeys.REMEMBERED_ME_DATA, value);
  }

  @override
  Future<String> getRememberMeData() async {
    return await _sharedPrefManager
            .getString(LocalStorageKeys.REMEMBERED_ME_DATA) ??
        "";
  }

  @override
  Future<bool> isRememberedMe() async {
    bool data =
        await _sharedPrefManager.getBool(LocalStorageKeys.IS_REMEMBERED_ME) ??
            false;
    return data;
  }

  @override
  Future<String> getMemberId() async {
    String memberId =
        await _sharedPrefManager.getString(LocalStorageKeys.MEMBER_ID) ?? '';
    return memberId;
  }

  // User Mode Management
  @override
  Future<void> setUserMode(UserModeModel userMode) async {
    await _sharedPrefManager.setObject(LocalStorageKeys.USER_MODE, userMode);
  }

  @override
  Future<UserModeModel?> getUserMode() async {
    return await _sharedPrefManager.getObject<UserModeModel>(
      LocalStorageKeys.USER_MODE,
      (json) => UserModeModel.fromJson(json),
    );
  }

  @override
  Future<void> setCurrentMode(UserMode mode) async {
    final currentUserMode = await getUserMode();
    final updatedUserMode = currentUserMode?.copyWith(currentMode: mode) ??
        UserModeModel(
          currentMode: mode,
          availableModes: [UserMode.passenger, UserMode.driver],
        );
    await setUserMode(updatedUserMode);
  }

  @override
  Future<UserMode> getCurrentMode() async {
    final userMode = await getUserMode();
    return userMode?.currentMode ?? UserMode.passenger;
  }

  @override
  Future<void> setAvailableModes(List<UserMode> modes) async {
    final currentUserMode = await getUserMode();
    final updatedUserMode = currentUserMode?.copyWith(availableModes: modes) ??
        UserModeModel(
          currentMode: UserMode.passenger,
          availableModes: modes,
        );
    await setUserMode(updatedUserMode);
  }

  @override
  Future<List<UserMode>> getAvailableModes() async {
    final userMode = await getUserMode();
    return userMode?.availableModes ?? [UserMode.passenger];
  }
}
