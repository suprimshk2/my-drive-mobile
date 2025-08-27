class LogoutPayload {
  final String deviceId;

  LogoutPayload({required this.deviceId});

  Map<String, dynamic> toJson() => {'deviceId': deviceId};
}
