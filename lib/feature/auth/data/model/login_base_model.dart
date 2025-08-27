import 'package:mydrivenepal/data/remote/status_codes.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_error_model.dart';
import 'package:mydrivenepal/feature/auth/data/model/login_success_model.dart';

class LoginBaseModel {
  bool isSuccess;
  LoginSuccessModel? successData;
  LoginErrorModel? errorData;

  LoginBaseModel({
    required this.isSuccess,
    this.successData,
    this.errorData,
  });

  factory LoginBaseModel.fromJson(Map<String, dynamic> json) {
    final isError = (json['code'] != null &&
        json['statusCode'] == HttpStatusCodes.Forbidden.code);

    return LoginBaseModel(
      isSuccess: !isError,
      successData: !isError ? LoginSuccessModel.fromJson(json) : null,
      errorData: isError ? LoginErrorModel.fromJson(json) : null,
    );
  }
}
