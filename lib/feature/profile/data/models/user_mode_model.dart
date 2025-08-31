import 'package:mydrivenepal/shared/interface/interface.dart';
import 'package:mydrivenepal/feature/profile/data/models/permission_model.dart';

enum UserMode {
  passenger('passenger', 'Passenger Mode', 'assets/icons/passenger_icon.svg'),
  rider('rider', 'Rider Mode', 'assets/icons/driver_icon.svg');

  const UserMode(this.value, this.displayName, this.iconPath);

  final String value;
  final String displayName;
  final String iconPath;

  static UserMode fromString(String value) {
    return UserMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => UserMode.passenger,
    );
  }

  // Enhanced role matching based on your API response
  bool matchesRoleCode(String? roleCode) {
    if (roleCode == null) return false;
    final normalizedRoleCode = roleCode.toLowerCase();
    switch (this) {
      case UserMode.rider:
        return normalizedRoleCode == 'rider' ||
            normalizedRoleCode.contains('rider') ||
            normalizedRoleCode.contains('operator');
      case UserMode.passenger:
        return normalizedRoleCode == 'passenger' ||
            normalizedRoleCode.contains('passenger') ||
            normalizedRoleCode.contains('user') ||
            normalizedRoleCode.contains('customer');
    }
  }

  // Get required permissions for this mode
  List<Permission> get requiredPermissions {
    switch (this) {
      case UserMode.passenger:
        return [
          Permission.userRead,
          Permission.userUpdate,
          Permission.tripCreate,
          Permission.tripRead,
          Permission.tripCancel,
          Permission.paymentCreate,
          Permission.paymentRead,
          Permission.notificationRead,
        ];
      case UserMode.rider:
        return [
          Permission.userRead,
          Permission.userUpdate,
          Permission.tripRead,
          Permission.driverAccept,
          Permission.driverReject,
          Permission.driverEarnings,
          Permission.paymentRead,
          Permission.notificationRead,
        ];
    }
  }
}

class UserModeModel extends JsonSerializable {
  final UserMode currentMode;
  final List<UserMode> availableModes;
  final bool isModeSwitchEnabled;
  final DateTime? lastUpdated;
  final String? lastUpdatedBy;
  final PermissionManager? permissionManager;

  UserModeModel({
    required this.currentMode,
    required this.availableModes,
    this.isModeSwitchEnabled = true,
    this.lastUpdated,
    this.lastUpdatedBy,
    this.permissionManager,
  });

  factory UserModeModel.fromJson(Map<String, dynamic> json) {
    return UserModeModel(
      currentMode: UserMode.fromString(json['currentMode'] ?? 'passenger'),
      availableModes: (json['availableModes'] as List<dynamic>?)
              ?.map((mode) => UserMode.fromString(mode.toString()))
              .toList() ??
          [UserMode.passenger, UserMode.rider],
      isModeSwitchEnabled: json['isModeSwitchEnabled'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
      lastUpdatedBy: json['lastUpdatedBy'],
      permissionManager: json['permissions'] != null
          ? PermissionManager(List<String>.from(json['permissions']))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'currentMode': currentMode.value,
        'availableModes': availableModes.map((mode) => mode.value).toList(),
        'isModeSwitchEnabled': isModeSwitchEnabled,
        'lastUpdated': lastUpdated?.toIso8601String(),
        'lastUpdatedBy': lastUpdatedBy,
        'permissions': permissionManager?.availablePermissions
            .map((p) => p.value)
            .toList(),
      };

  UserModeModel copyWith({
    UserMode? currentMode,
    List<UserMode>? availableModes,
    bool? isModeSwitchEnabled,
    DateTime? lastUpdated,
    String? lastUpdatedBy,
    PermissionManager? permissionManager,
  }) {
    return UserModeModel(
      currentMode: currentMode ?? this.currentMode,
      availableModes: availableModes ?? this.availableModes,
      isModeSwitchEnabled: isModeSwitchEnabled ?? this.isModeSwitchEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      permissionManager: permissionManager ?? this.permissionManager,
    );
  }

  // Enhanced getters with permission integration
  bool get canSwitchToDriver => availableModes.contains(UserMode.rider);
  bool get canSwitchToPassenger => availableModes.contains(UserMode.passenger);
  bool get isDriverMode => currentMode == UserMode.rider;
  bool get isPassengerMode => currentMode == UserMode.passenger;
  bool get hasMultipleModes => availableModes.length > 1;
  bool get isModeValid => availableModes.contains(currentMode);

  // Permission-based getters
  bool get canBookTrips => permissionManager?.canBookTrips ?? false;
  bool get canViewTrips => permissionManager?.canViewTrips ?? false;
  bool get canCancelTrips => permissionManager?.canCancelTrips ?? false;
  bool get canAcceptRides => permissionManager?.canAcceptRides ?? false;
  bool get canViewEarnings => permissionManager?.canViewEarnings ?? false;
  bool get canManageProfile => permissionManager?.canManageProfile ?? false;
  bool get canMakePayments => permissionManager?.canMakePayments ?? false;
  bool get canReceiveNotifications =>
      permissionManager?.canReceiveNotifications ?? false;
}
