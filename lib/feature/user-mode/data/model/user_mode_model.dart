import 'package:mydrivenepal/shared/interface/interface.dart';

enum UserMode {
  passenger('passenger', 'Passenger Mode'),
  driver('driver', 'Driver Mode');

  const UserMode(this.value, this.displayName);

  final String value;
  final String displayName;

  static UserMode fromString(String value) {
    return UserMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => UserMode.passenger,
    );
  }
}

class UserModeModel extends JsonSerializable {
  final UserMode currentMode;
  final List<UserMode> availableModes;
  final bool isModeSwitchEnabled;

  UserModeModel({
    required this.currentMode,
    required this.availableModes,
    this.isModeSwitchEnabled = true,
  });

  factory UserModeModel.fromJson(Map<String, dynamic> json) {
    return UserModeModel(
      currentMode: UserMode.fromString(json['currentMode'] ?? 'passenger'),
      availableModes: (json['availableModes'] as List<dynamic>?)
              ?.map((mode) => UserMode.fromString(mode.toString()))
              .toList() ??
          [UserMode.passenger, UserMode.driver],
      isModeSwitchEnabled: json['isModeSwitchEnabled'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'currentMode': currentMode.value,
        'availableModes': availableModes.map((mode) => mode.value).toList(),
        'isModeSwitchEnabled': isModeSwitchEnabled,
      };

  UserModeModel copyWith({
    UserMode? currentMode,
    List<UserMode>? availableModes,
    bool? isModeSwitchEnabled,
  }) {
    return UserModeModel(
      currentMode: currentMode ?? this.currentMode,
      availableModes: availableModes ?? this.availableModes,
      isModeSwitchEnabled: isModeSwitchEnabled ?? this.isModeSwitchEnabled,
    );
  }

  bool get canSwitchToDriver => availableModes.contains(UserMode.driver);
  bool get canSwitchToPassenger => availableModes.contains(UserMode.passenger);
  bool get isDriverMode => currentMode == UserMode.driver;
  bool get isPassengerMode => currentMode == UserMode.passenger;
}
