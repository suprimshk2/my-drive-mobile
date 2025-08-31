import 'dart:convert';

class UserRoleResponse {
  final String id;
  final String name;
  final String description;

  UserRoleResponse({
    required this.id,
    required this.name,
    required this.description,
  });

  factory UserRoleResponse.fromJson(Map<String, dynamic> json) {
    return UserRoleResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };

  static List<UserRoleResponse> fromJsonList(dynamic json) =>
      List<UserRoleResponse>.from(
          json.map((x) => UserRoleResponse.fromJson(x)));
}
