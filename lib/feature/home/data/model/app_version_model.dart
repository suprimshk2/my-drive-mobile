// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

AppUpdateModel appUpdateModelFromJson(String str) => AppUpdateModel.fromJson(json.decode(str));

String appUpdateModelToJson(AppUpdateModel data) => json.encode(data.toJson());

class AppUpdateModel {
    bool found;
    bool? forceUpgrade;

    AppUpdateModel({
        required this.found,
        this.forceUpgrade,
    });

    factory AppUpdateModel.fromJson(Map<String, dynamic> json) => AppUpdateModel(
        found: json["found"] ?? false,
        forceUpgrade: json["forceUpgrade"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "found": found,
        "forceUpgrade": forceUpgrade,
    };
}

class AppVersionModel {
  String version;
  String buildNumber;
  String platform;
  
  AppVersionModel({
    required this.version,
    required this.buildNumber,
    required this.platform,
  });
}
