class VerifyCodeResponse {
  final bool? isVerified;
  final User? user;

  VerifyCodeResponse({
    this.isVerified,
    this.user,
  });

  factory VerifyCodeResponse.fromJson(Map<String, dynamic> json) =>
      VerifyCodeResponse(
        isVerified: json["isVerified"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "isVerified": isVerified,
        "user": user?.toJson(),
      };
}

class User {
  final num? userId;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? expiryDate;
  final bool? isSsoCreated;

  User({
    this.userId,
    this.email,
    this.expiryDate,
    this.isSsoCreated,
    this.phone,
    this.firstName,
    this.middleName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        email: json["email"],
        expiryDate: json["expiryDate"],
        isSsoCreated: json["isSSOCreated"],
        phone: json["phone"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "expiryDate": expiryDate,
        "isSSOCreated": isSsoCreated,
        "phone": phone,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
      };
}
