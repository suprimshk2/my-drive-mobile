import 'dart:convert';

List<DeveloperOptionModel> developerOptionFromJson(String str) =>
    List<DeveloperOptionModel>.from(
        json.decode(str).map((x) => DeveloperOptionModel.fromJson(x)));

String developerOptionToJson(List<DeveloperOptionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeveloperOptionModel {
  String env;
  String baseUrl;

  DeveloperOptionModel({
    required this.env,
    required this.baseUrl,
  });

  factory DeveloperOptionModel.fromJson(Map<String, dynamic> json) =>
      DeveloperOptionModel(
        env: json["label"],
        baseUrl: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": env,
        "value": baseUrl,
      };
}
