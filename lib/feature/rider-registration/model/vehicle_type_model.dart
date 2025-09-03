class VehicleTypeModel {
  final String id;
  final String name;
  final String displayName;
  final bool isActive;

  const VehicleTypeModel({
    required this.id,
    required this.name,
    required this.displayName,
    this.isActive = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => displayName;
}
