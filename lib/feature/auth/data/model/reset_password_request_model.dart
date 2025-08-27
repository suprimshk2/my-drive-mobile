class ResetPasswordRequestModel {
  final String? email;
  final String? password;
  final int? id;

  ResetPasswordRequestModel({
    this.email,
    this.password,
    this.id,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordRequestModel(
        email: json["email"],
        password: json["password"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "id": id,
      };
}
