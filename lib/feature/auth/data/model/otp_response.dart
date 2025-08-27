import 'package:mydrivenepal/shared/interface/interface.dart';

class LoginResponseModel {
  String accessToken;
  User user;

  LoginResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json["accessToken"],
        user: User.fromJson(json["user"]),
      );
}

class User extends JsonSerializable {
  String? id;
  String currentRole;
  String email;
  String? phoneNumber;

  User({
    required this.id,
    required this.currentRole,
    required this.email,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? "",
        currentRole: json["currentRole"],
        email: json["email"],
        phoneNumber: json["phoneNumber"] ?? "",
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "currentRole": currentRole,
        "email": email,
        "phoneNumber": phoneNumber,
      };
}

class CreatedDateModel {
  String date;
  String name;

  CreatedDateModel({
    required this.date,
    required this.name,
  });

  factory CreatedDateModel.fromJson(Map<String, dynamic> json) =>
      CreatedDateModel(
        date: json["date"],
        name: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "date": date,
        "name": name,
      };
}
