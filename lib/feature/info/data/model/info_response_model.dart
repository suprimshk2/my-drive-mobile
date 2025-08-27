class InfoResponseModel {
  int id;
  String name;
  String documentPath;
  DateTime createdAt;
  DateTime updatedAt;

  InfoResponseModel({
    required this.id,
    required this.name,
    required this.documentPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InfoResponseModel.fromJson(Map<String, dynamic> json) =>
      InfoResponseModel(
        id: json["id"],
        name: json["name"],
        documentPath: json["documentPath"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "documentPath": documentPath,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
  static List<InfoResponseModel> fromJsonList(dynamic json) =>
      List<InfoResponseModel>.from(
          json.map((x) => InfoResponseModel.fromJson(x)));
}
