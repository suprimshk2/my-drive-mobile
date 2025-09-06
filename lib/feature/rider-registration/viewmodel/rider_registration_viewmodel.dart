import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/rider-registration/model/vehicle_type_model.dart';
import 'package:mydrivenepal/feature/rider-registration/data/repository/rider_registration_repository.dart';
import 'package:mydrivenepal/feature/rider-registration/data/model/rider_registration_request.dart';
import 'package:mydrivenepal/data/remote/data/model/api_response.dart';
import 'package:mydrivenepal/shared/util/response.dart';
import '../model/rider_registration_model.dart';

class RiderRegistrationViewModel extends ChangeNotifier {
  final RiderRegistrationRepository _repository;

  RiderRegistrationModel _registrationData = RiderRegistrationModel();
  bool _isLoading = false;
  String? _errorMessage;
  // int _uploadProgress = 0;

  RiderRegistrationViewModel({required RiderRegistrationRepository repository})
      : _repository = repository;

  RiderRegistrationModel get registrationData => _registrationData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  // int get uploadProgress => _uploadProgress;

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
    String? phoneNumber,
  }) {
    _registrationData = _registrationData.copyWith(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      email: email,
      profilePhoto: profilePhoto,
      phoneNumber: phoneNumber,
    );
    notifyListeners();
  }

  void updateDriverLicense({
    String? driverLicenseNumber,
    String? driverLicenseFrontPhoto,
    String? nationalIdFrontPhoto,
    String? driverLicense,
  }) {
    _registrationData = _registrationData.copyWith(
      driverLicenseNumber: driverLicenseNumber,
      driverLicenseFrontPhoto: driverLicenseFrontPhoto,
      nationalIdFrontPhoto: nationalIdFrontPhoto,
      driverLicense: driverLicense,
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

  // void _updateUploadProgress(int sent, int total) {
  //   _uploadProgress = ((sent / total) * 100).round();
  //   notifyListeners();
  // }

  // Response<RiderRegistrationResponse> _riderRegistrationUsecase =
  //     Response<RiderRegistrationResponse>();
  // Response<RiderRegistrationResponse> get riderRegistrationUsecase =>
  //     _riderRegistrationUsecase;

  // set riderRegistrationUsecase(Response<RiderRegistrationResponse> response) {
  //   _riderRegistrationUsecase = response;
  //   notifyListeners();
  // }
  Response<dynamic> _riderRegistrationUsecase = Response<dynamic>();
  Response<dynamic> get riderRegistrationUsecase => _riderRegistrationUsecase;

  set riderRegistrationUsecase(Response<dynamic> response) {
    _riderRegistrationUsecase = response;
    notifyListeners();
  }

  Future<void> submitRegistration() async {
    if (!_registrationData.isRegistrationComplete) {
      setError('Please complete all required fields');
      return;
    }

    // _uploadProgress = 0;

    try {
      riderRegistrationUsecase = Response.loading();
      // Create request from registration data
      final request =
          RiderRegistrationRequest.fromRegistrationModel(_registrationData);

      // Submit registration with progress tracking
      final response = await _repository.submitRiderRegistration(
        request: request,

        // onSendProgress: _updateUploadProgress,
      );

      riderRegistrationUsecase = Response.complete(response);
    } catch (e) {
      riderRegistrationUsecase = Response.error(e);
    }
  }
}
