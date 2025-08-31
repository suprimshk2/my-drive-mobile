import 'dart:convert';

class SwitchUserModeResponse {
  final String accessToken;
  final AuthUser user;

  SwitchUserModeResponse({
    required this.accessToken,
    required this.user,
  });

  factory SwitchUserModeResponse.fromJson(Map<String, dynamic> json) {
    return SwitchUserModeResponse(
      accessToken: json['accessToken'] as String,
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  factory SwitchUserModeResponse.fromRawJson(String str) =>
      SwitchUserModeResponse.fromJson(jsonDecode(str) as Map<String, dynamic>);

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'user': user.toJson(),
      };

  String get bearer => 'Bearer $accessToken';
}

class AuthUser {
  final String id;
  final String email;
  final String currentRole;

  AuthUser({
    required this.id,
    required this.email,
    required this.currentRole,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      currentRole: json['currentRole'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'currentRole': currentRole,
      };
}
