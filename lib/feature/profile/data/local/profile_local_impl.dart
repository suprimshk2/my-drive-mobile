import 'dart:convert';
import 'package:mydrivenepal/data/local/local_storage_client.dart';
import 'package:mydrivenepal/data/local/local_storage_keys.dart';
import 'package:mydrivenepal/feature/profile/data/local/profile_local.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_mode_model.dart';
import 'package:mydrivenepal/data/model/fetch_list_response.dart';
import 'package:mydrivenepal/feature/profile/data/models/user_role_response.dart';

class ProfileLocalImpl implements ProfileLocal {
  final LocalStorageClient _localStorageClient;

  ProfileLocalImpl({
    required LocalStorageClient localStorageClient,
  }) : _localStorageClient = localStorageClient;

  // User Mode Implementation
  @override
  Future<void> setUserMode(UserModeModel userMode) async {
    await _localStorageClient.setString(
      LocalStorageKeys.userMode,
      jsonEncode(userMode.toJson()),
    );
  }

  @override
  Future<UserModeModel?> getUserMode() async {
    final userModeString = await _localStorageClient.getString(
      LocalStorageKeys.userMode,
    );
    if (userModeString != null) {
      try {
        final json = jsonDecode(userModeString) as Map<String, dynamic>;
        return UserModeModel.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> setCurrentMode(UserMode mode) async {
    await _localStorageClient.setString(
      LocalStorageKeys.currentUserMode,
      mode.value,
    );
  }

  @override
  Future<UserMode> getCurrentMode() async {
    final modeString = await _localStorageClient.getString(
      LocalStorageKeys.currentUserMode,
    );
    return UserMode.fromString(modeString ?? 'passenger');
  }

  @override
  Future<void> setAvailableModes(List<UserMode> modes) async {
    final modeStrings = modes.map((mode) => mode.value).toList();
    await _localStorageClient.setStringList(
      LocalStorageKeys.availableUserModes,
      modeStrings,
    );
  }

  @override
  Future<List<UserMode>> getAvailableModes() async {
    final modeStrings = await _localStorageClient.getStringList(
      LocalStorageKeys.availableUserModes,
    );
    if (modeStrings != null) {
      return modeStrings.map((mode) => UserMode.fromString(mode)).toList();
    }
    return [UserMode.passenger, UserMode.rider];
  }

  @override
  Future<void> clearUserMode() async {
    await _localStorageClient.remove(LocalStorageKeys.userMode);
    await _localStorageClient.remove(LocalStorageKeys.currentUserMode);
    await _localStorageClient.remove(LocalStorageKeys.availableUserModes);
  }

  // User roles caching implementation
  @override
  Future<void> setUserRoles(
      FetchListResponse<UserRoleResponse> userRoles) async {
    // Create a custom serialization since FetchListResponse doesn't have toJson
    final serializedData = {
      'rows': userRoles.rows.map((role) => role.toJson()).toList(),
      'count': userRoles.count,
    };

    await _localStorageClient.setString(
      LocalStorageKeys.userRoles,
      jsonEncode(serializedData),
    );
  }

  @override
  Future<FetchListResponse<UserRoleResponse>?> getUserRoles() async {
    final userRolesString = await _localStorageClient.getString(
      LocalStorageKeys.userRoles,
    );
    if (userRolesString != null) {
      try {
        final json = jsonDecode(userRolesString) as Map<String, dynamic>;
        final rows = (json['rows'] as List)
            .map((roleJson) =>
                UserRoleResponse.fromJson(roleJson as Map<String, dynamic>))
            .toList();
        final count = json['count'] as int;

        return FetchListResponse<UserRoleResponse>(
          rows: rows,
          count: count,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearUserRoles() async {
    await _localStorageClient.remove(LocalStorageKeys.userRoles);
  }
}
