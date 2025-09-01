import 'package:flutter/material.dart';
import 'package:mydrivenepal/shared/shared.dart';
import '../model/rider_registration_model.dart';

class RiderRegistrationViewModel extends ChangeNotifier {
  RiderRegistrationModel _registrationData = RiderRegistrationModel();
  bool _isLoading = false;
  String? _errorMessage;

  RiderRegistrationModel get registrationData => _registrationData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
    String? billbookPhoto,
  }) {
    _registrationData = _registrationData.copyWith(
      vehicleBrand: vehicleBrand,
      vehiclePhoto: vehiclePhoto,
      registrationPlate: registrationPlate,
      billbookPhoto: billbookPhoto,
    );
    notifyListeners();
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
