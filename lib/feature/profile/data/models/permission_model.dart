import 'dart:convert';

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

enum Permission {
  // User permissions
  userRead('user:read'),
  userUpdate('user:update'),
  userDelete('user:delete'),
  userCreate('user:create'),

  // Trip permissions
  tripCreate('trip:create'),
  tripRead('trip:read'),
  tripUpdate('trip:update'),
  tripCancel('trip:cancel'),
  tripDelete('trip:delete'),

  // Payment permissions
  paymentCreate('payment:create'),
  paymentRead('payment:read'),
  paymentUpdate('payment:update'),
  paymentRefund('payment:refund'),

  // Notification permissions
  notificationRead('notification:read'),
  notificationCreate('notification:create'),
  notificationUpdate('notification:update'),

  // Driver specific permissions
  driverAccept('driver:accept'),
  driverReject('driver:reject'),
  driverEarnings('driver:earnings'),

  // Admin permissions
  adminAll('admin:all'),
  adminUsers('admin:users'),
  adminTrips('admin:trips'),
  adminPayments('admin:payments');

  const Permission(this.value);
  final String value;

  static Permission fromString(String value) {
    return Permission.values.firstWhere(
      (permission) => permission.value == value,
      orElse: () => throw ArgumentError('Unknown permission: $value'),
    );
  }

  static List<Permission> fromStrings(List<String> values) {
    return values.map((value) => fromString(value)).toList();
  }
}

class PermissionManager {
  final List<String> _userPermissions;

  PermissionManager(this._userPermissions);

  bool hasPermission(Permission permission) {
    return _userPermissions.contains(permission.value);
  }

  bool hasAnyPermission(List<Permission> permissions) {
    return permissions.any((permission) => hasPermission(permission));
  }

  bool hasAllPermissions(List<Permission> permissions) {
    return permissions.every((permission) => hasPermission(permission));
  }

  List<Permission> get availablePermissions {
    return _userPermissions
        .map((permission) => Permission.fromString(permission))
        .toList();
  }

  // Permission groups for common operations
  bool get canManageProfile =>
      hasPermission(Permission.userRead) &&
      hasPermission(Permission.userUpdate);
  bool get canBookTrips => hasPermission(Permission.tripCreate);
  bool get canViewTrips => hasPermission(Permission.tripRead);
  bool get canCancelTrips => hasPermission(Permission.tripCancel);
  bool get canMakePayments => hasPermission(Permission.paymentCreate);
  bool get canViewPayments => hasPermission(Permission.paymentRead);
  bool get canReceiveNotifications =>
      hasPermission(Permission.notificationRead);
  bool get canAcceptRides => hasPermission(Permission.driverAccept);
  bool get canViewEarnings => hasPermission(Permission.driverEarnings);
  bool get isAdmin => hasPermission(Permission.adminAll);
}
