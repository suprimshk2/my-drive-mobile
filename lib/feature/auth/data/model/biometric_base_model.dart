import 'package:mydrivenepal/data/remote/status_codes.dart';
import 'package:mydrivenepal/feature/auth/data/model/biometric_login_reponse.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_error_model.dart';

class BiometricBaseModel {
  bool isSuccess;
  BiometricLoginResponseModel? successData;
  LoginErrorModel? errorData;

  BiometricBaseModel({
    required this.isSuccess,
    this.successData,
    this.errorData,
  });

  factory BiometricBaseModel.fromJson(Map<String, dynamic> json) {
    final isError = (json['code'] != null &&
        json['statusCode'] == HttpStatusCodes.Forbidden.code);

    return BiometricBaseModel(
      isSuccess: !isError,
      successData: !isError ? BiometricLoginResponseModel.fromJson(json) : null,
      errorData: isError ? LoginErrorModel.fromJson(json) : null,
    );
  }
}
