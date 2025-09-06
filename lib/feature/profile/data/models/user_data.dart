import 'dart:convert';

class UserDataResponse {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  bool? isActive;
  DateTime? lastLoginAt;
  List<Role>? roles;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? providerType;
  String? providerId;
  ProviderData? providerData;
  String? currentRole;
  List<String>? roleNames;
  String? dateOfBirth;
  String? phoneNumber;

  UserDataResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.isActive,
    this.lastLoginAt,
    this.roles,
    this.createdAt,
    this.updatedAt,
    this.providerType,
    this.providerId,
    this.providerData,
    this.currentRole,
    this.roleNames,
    this.dateOfBirth,
    this.phoneNumber,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      isActive: json['isActive'],
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      roles: json['roles'] != null
          ? List<Role>.from(json['roles'].map((x) => Role.fromJson(x)))
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      providerType: json['providerType'],
      providerId: json['providerId'],
      providerData: json['providerData'] != null
          ? ProviderData.fromJson(jsonDecode(json['providerData']))
          : null,
      currentRole: json['currentRole'],
      dateOfBirth: json['dateOfBirth'],
      roleNames: json['roleNames'] != null
          ? List<String>.from(json['roleNames'])
          : null,
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isActive': isActive,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'roles': roles?.map((x) => x.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'providerType': providerType,
      'providerId': providerId,
      'providerData': providerData?.toJson(),
      'currentRole': currentRole,
      'roleNames': roleNames,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
    };
  }

  // Helper methods for user data
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  String get displayName => fullName.isNotEmpty ? fullName : email ?? '';
  String? get profilePicture => providerData?.picture;
  bool get hasProfilePicture =>
      profilePicture != null && profilePicture!.isNotEmpty;
}

class Role {
  String? id;
  String? name;
  String? description;
  List<String>? permissions;

  Role({
    this.id,
    this.name,
    this.description,
    this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions,
    };
  }

  // Helper methods for role validation
  bool hasPermission(String permission) {
    return permissions?.contains(permission) ?? false;
  }

  bool hasAnyPermission(List<String> requiredPermissions) {
    return permissions
            ?.any((permission) => requiredPermissions.contains(permission)) ??
        false;
  }

  bool hasAllPermissions(List<String> requiredPermissions) {
    return permissions
            ?.every((permission) => requiredPermissions.contains(permission)) ??
        false;
  }

  bool get isPassengerRole => name?.toLowerCase() == 'passenger';
  bool get isDriverRole => name?.toLowerCase() == 'driver';
  bool get isAdminRole => name?.toLowerCase() == 'admin';
}

class ProviderData {
  String? googleId;
  String? picture;
  String? displayName;
  String? profileUrl;

  ProviderData({
    this.googleId,
    this.picture,
    this.displayName,
    this.profileUrl,
  });

  factory ProviderData.fromJson(Map<String, dynamic> json) {
    return ProviderData(
      googleId: json['googleId'],
      picture: json['picture'],
      displayName: json['displayName'],
      profileUrl: json['profileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'googleId': googleId,
      'picture': picture,
      'displayName': displayName,
      'profileUrl': profileUrl,
    };
  }
}
