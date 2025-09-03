import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/rider-registration/model/vehicle_type_model.dart';
import '../model/rider_registration_model.dart';

class RiderRegistrationViewModel extends ChangeNotifier {
  RiderRegistrationModel _registrationData = RiderRegistrationModel();
  bool _isLoading = false;
  String? _errorMessage;

  RiderRegistrationModel get registrationData => _registrationData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Vehicle types data
  final List<VehicleTypeModel> _vehicleTypes = [
    const VehicleTypeModel(id: 'Car', name: 'Car', displayName: 'Car'),
    const VehicleTypeModel(
        id: 'Motorcycle', name: 'Motorcycle', displayName: 'Motorcycle'),
    const VehicleTypeModel(
        id: 'Scooter', name: 'Scooter', displayName: 'Scooter'),
  ];

  List<VehicleTypeModel> get vehicleTypes => _vehicleTypes;

  // Get vehicle type by ID
  VehicleTypeModel? getVehicleTypeById(String? id) {
    if (id == null) return null;
    try {
      return _vehicleTypes.firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get current vehicle type model
  VehicleTypeModel? get currentVehicleType =>
      getVehicleTypeById(_registrationData.vehicleType);

  // Get dropdown items for vehicle types
  List<DropdownMenuItem<String>> get vehicleTypeDropdownItems => _vehicleTypes
      .map((type) => DropdownMenuItem(
            value: type.id,
            child: Text(type.displayName),
          ))
      .toList();

  void updateBasicInfo({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? email,
    String? profilePhoto,
  }) {
    _registrationData = _registrationData.copyWith(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      email: email,
      profilePhoto: profilePhoto,
    );
    notifyListeners();
  }

  void updateDriverLicense({
    String? driverLicenseNumber,
    String? driverLicenseFrontPhoto,
    String? nationalIdFrontPhoto,
  }) {
    _registrationData = _registrationData.copyWith(
      driverLicenseNumber: driverLicenseNumber,
      driverLicenseFrontPhoto: driverLicenseFrontPhoto,
      nationalIdFrontPhoto: nationalIdFrontPhoto,
    );
    notifyListeners();
  }

  void updateVehicleInfo({
    String? vehicleBrand,
    String? vehiclePhoto,
    String? registrationPlate,
    String? vehicleRegistrationNumberPhoto,
    String? vehicleRegistrationDetailsPhoto,
    String? vehicleProductionYear,
    String? vehicleType,
  }) {
    _registrationData = _registrationData.copyWith(
      vehicleBrand: vehicleBrand,
      vehiclePhoto: vehiclePhoto,
      registrationPlate: registrationPlate,
      vehicleRegistrationNumberPhoto: vehicleRegistrationNumberPhoto,
      vehicleRegistrationDetailsPhoto: vehicleRegistrationDetailsPhoto,
      vehicleProductionYear: vehicleProductionYear,
      vehicleType: vehicleType,
    );
    notifyListeners();
  }

  void updateVehicleType(String? vehicleType) {
    updateVehicleInfo(vehicleType: vehicleType);
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<bool> submitRegistration() async {
    if (!_registrationData.isRegistrationComplete) {
      setError('Please complete all required fields');
      return false;
    }

    setLoading(true);
    setError(null);

    try {
      // TODO: Implement API call to submit registration
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      setError('Failed to submit registration. Please try again.');
      return false;
    }
  }
}
