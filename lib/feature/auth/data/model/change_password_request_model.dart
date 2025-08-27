class ChangePasswordRequestModel {
  final String? oldPassword;
  final String? email;
  final String? newPassword;
  final int? userId;

  ChangePasswordRequestModel({
    this.oldPassword,
    this.email,
    this.newPassword,
    this.userId,
  });

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordRequestModel(
        oldPassword: json["oldPassword"],
        email: json["email"],
        newPassword: json["newPassword"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "oldPassword": oldPassword,
        "email": email,
        "newPassword": newPassword,
        "userId": userId,
      };
}
