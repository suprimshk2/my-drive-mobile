class LoginErrorModel {
  final String? message;
  final int? statusCode;
  final String? name;
  final String? code;

  LoginErrorModel({
    this.message,
    this.statusCode,
    this.name,
    this.code,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
      'statusCode': statusCode,
      'name': name,
      'code': code,
    };
  }

  factory LoginErrorModel.fromJson(Map<String, dynamic> map) {
    return LoginErrorModel(
      message: map['message'] as String?,
      statusCode: map['statusCode'] as int?,
      name: map['name'] as String?,
      code: map['code'] as String?,
    );
  }
}
