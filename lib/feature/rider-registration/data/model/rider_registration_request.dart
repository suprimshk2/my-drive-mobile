class RiderRegistrationRequest {
  final String? metadata;
  final String? driverLicenseNumber;
  final String? ninCard;
  final String? additionalDocuments;
  final String? bluebookFile;
  final String? vehicleAdditionalDocuments;
  final String? vehicleRegistrationNumberPhoto;
  final String? vehicleRegistrationDetailsPhoto;
  final String? vehicleProductionYear;
  final String? vehicleType;
  final String? vehicleBrand;
  final String? registrationPlate;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? driverLicense;
  final String? vehiclePhoto;
  final String? nationalIdFrontPhoto;

  RiderRegistrationRequest({
    this.metadata,
    this.driverLicenseNumber,
    this.ninCard,
    this.additionalDocuments,
    this.vehicleRegistrationNumberPhoto,
    this.vehicleRegistrationDetailsPhoto,
    this.vehicleProductionYear,
    this.vehicleType,
    this.vehicleBrand,
    this.registrationPlate,
    this.bluebookFile,
    this.vehicleAdditionalDocuments,
    this.phoneNumber,
    this.dateOfBirth,
    this.driverLicense,
    this.vehiclePhoto,
    this.nationalIdFrontPhoto,
  });

  factory RiderRegistrationRequest.fromRegistrationModel(
    dynamic registrationData,
  ) {
    // Create metadata JSON string
    final metadata = <String, dynamic>{
      'color': 'red', // You can make this dynamic based on your needs
      'fuelType': 'petrol', // You can make this dynamic based on your needs
    };

    return RiderRegistrationRequest(
      metadata: _mapToJsonString(metadata),
      ninCard: registrationData.nationalIdFrontPhoto,
      additionalDocuments: null, // Optional field
      vehicleRegistrationNumberPhoto:
          registrationData.vehicleRegistrationNumberPhoto,
      vehicleRegistrationDetailsPhoto:
          registrationData.vehicleRegistrationDetailsPhoto,
      vehicleProductionYear: registrationData.vehicleProductionYear,
      vehicleType: registrationData.vehicleType,
      vehicleBrand: registrationData.vehicleBrand,
      registrationPlate: registrationData.registrationPlate,
      bluebookFile: registrationData.vehicleRegistrationNumberPhoto,
      vehicleAdditionalDocuments:
          registrationData.vehicleRegistrationDetailsPhoto,
      phoneNumber: registrationData.phoneNumber,
      driverLicenseNumber: registrationData.driverLicenseNumber,
      driverLicense: registrationData.driverLicense,
      dateOfBirth: registrationData.dateOfBirth,
      vehiclePhoto: registrationData.vehiclePhoto,
      nationalIdFrontPhoto: registrationData.nationalIdFrontPhoto,
    );
  }

  static String _mapToJsonString(Map<String, dynamic> map) {
    // Simple JSON string conversion
    final buffer = StringBuffer();
    buffer.write('{');
    map.entries.forEach((entry) {
      buffer.write('"${entry.key}":"${entry.value}"');
      if (entry != map.entries.last) {
        buffer.write(',');
      }
    });
    buffer.write('}');
    return buffer.toString();
  }
}
