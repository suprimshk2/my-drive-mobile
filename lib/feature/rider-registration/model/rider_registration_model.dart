class RiderRegistrationModel {
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? email;
  final String? profilePhoto;
  final String? driverLicenseNumber;
  final String? driverLicenseFrontPhoto;
  final String? nationalIdFrontPhoto;
  final String? vehicleBrand;
  final String? vehiclePhoto;
  final String? registrationPlate;
  final String? vehicleRegistrationNumberPhoto;
  final String? vehicleRegistrationDetailsPhoto;
  final String? vehicleProductionYear;
  final String? vehicleType;
  final String? phoneNumber;
  final String? driverLicense;

  RiderRegistrationModel({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.email,
    this.profilePhoto,
    this.driverLicenseNumber,
    this.driverLicenseFrontPhoto,
    this.nationalIdFrontPhoto,
    this.vehicleBrand,
    this.vehiclePhoto,
    this.registrationPlate,
    this.vehicleRegistrationNumberPhoto,
    this.vehicleRegistrationDetailsPhoto,
    this.vehicleProductionYear,
    this.vehicleType,
    this.phoneNumber,
    this.driverLicense,
  });

  RiderRegistrationModel copyWith({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? email,
    String? profilePhoto,
    String? driverLicenseNumber,
    String? driverLicenseFrontPhoto,
    String? nationalIdFrontPhoto,
    String? vehicleBrand,
    String? vehiclePhoto,
    String? registrationPlate,
    String? vehicleRegistrationNumberPhoto,
    String? vehicleRegistrationDetailsPhoto,
    String? vehicleProductionYear,
    String? vehicleType,
    String? phoneNumber,
    String? driverLicense,
  }) {
    return RiderRegistrationModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      driverLicenseNumber: driverLicenseNumber ?? this.driverLicenseNumber,
      driverLicenseFrontPhoto:
          driverLicenseFrontPhoto ?? this.driverLicenseFrontPhoto,
      nationalIdFrontPhoto: nationalIdFrontPhoto ?? this.nationalIdFrontPhoto,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehiclePhoto: vehiclePhoto ?? this.vehiclePhoto,
      registrationPlate: registrationPlate ?? this.registrationPlate,
      vehicleRegistrationNumberPhoto:
          vehicleRegistrationNumberPhoto ?? this.vehicleRegistrationNumberPhoto,
      vehicleRegistrationDetailsPhoto: vehicleRegistrationDetailsPhoto ??
          this.vehicleRegistrationDetailsPhoto,
      vehicleProductionYear:
          vehicleProductionYear ?? this.vehicleProductionYear,
      vehicleType: vehicleType ?? this.vehicleType,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      driverLicense: driverLicense ?? this.driverLicense,
    );
  }

  bool get isBasicInfoComplete =>
      firstName?.isNotEmpty == true &&
      lastName?.isNotEmpty == true &&
      dateOfBirth?.isNotEmpty == true &&
      phoneNumber?.isNotEmpty == true;

  bool get isDriverLicenseComplete =>
      driverLicenseNumber?.isNotEmpty == true &&
      driverLicenseFrontPhoto?.isNotEmpty == true &&
      nationalIdFrontPhoto?.isNotEmpty == true &&
      driverLicense?.isNotEmpty == true;

  bool get isVehicleInfoComplete =>
      vehicleBrand?.isNotEmpty == true &&
      vehiclePhoto?.isNotEmpty == true &&
      vehicleType?.isNotEmpty == true &&
      registrationPlate?.isNotEmpty == true &&
      vehicleRegistrationNumberPhoto?.isNotEmpty == true &&
      vehicleRegistrationDetailsPhoto?.isNotEmpty == true &&
      vehicleProductionYear?.isNotEmpty == true;

  bool get isRegistrationComplete =>
      isBasicInfoComplete && isDriverLicenseComplete && isVehicleInfoComplete;
}
