import 'dart:convert';

List<EocListResponseModel> eocListResponseModelFromJson(String str) =>
    List<EocListResponseModel>.from(
        json.decode(str).map((x) => EocListResponseModel.fromJson(x)));

String eocListResponseModelToJson(List<EocListResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EocListResponseModel {
  int id;
  String networkCode;
  String name;
  String uuid;
  dynamic description;
  String bundleUuid;
  String pathwayUuid;
  int categoryId;
  dynamic subCategoryId;
  bool isArchive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic archivedBy;
  dynamic archivedAt;
  Bundle pathway;
  Bundle bundle;
  Network network;
  List<FundingTrigger> fundingTriggers;

  EocListResponseModel({
    required this.id,
    required this.networkCode,
    required this.name,
    required this.uuid,
    required this.description,
    required this.bundleUuid,
    required this.pathwayUuid,
    required this.categoryId,
    required this.subCategoryId,
    required this.isArchive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.archivedBy,
    required this.archivedAt,
    required this.pathway,
    required this.bundle,
    required this.network,
    required this.fundingTriggers,
  });

  factory EocListResponseModel.fromJson(Map<String, dynamic> json) =>
      EocListResponseModel(
        id: json["id"],
        networkCode: json["networkCode"],
        name: json["name"],
        uuid: json["uuid"],
        description: json["description"],
        bundleUuid: json["bundleUuid"],
        pathwayUuid: json["pathwayUuid"],
        categoryId: json["categoryId"],
        subCategoryId: json["subCategoryId"],
        isArchive: json["isArchive"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        archivedBy: json["archivedBy"],
        archivedAt: json["archivedAt"],
        pathway: Bundle.fromJson(json["pathway"]),
        bundle: Bundle.fromJson(json["bundle"]),
        network: Network.fromJson(json["network"]),
        fundingTriggers: List<FundingTrigger>.from(
            json["fundingTriggers"].map((x) => FundingTrigger.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "networkCode": networkCode,
        "name": name,
        "uuid": uuid,
        "description": description,
        "bundleUuid": bundleUuid,
        "pathwayUuid": pathwayUuid,
        "categoryId": categoryId,
        "subCategoryId": subCategoryId,
        "isArchive": isArchive,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "archivedBy": archivedBy,
        "archivedAt": archivedAt,
        "pathway": pathway.toJson(),
        "bundle": bundle.toJson(),
        "network": network.toJson(),
        "fundingTriggers":
            List<dynamic>.from(fundingTriggers.map((x) => x.toJson())),
      };
  static List<EocListResponseModel> fromJsonList(dynamic json) =>
      List<EocListResponseModel>.from(
          json.map((x) => EocListResponseModel.fromJson(x)));
}

class Bundle {
  int id;
  String uuid;
  String networkCode;
  String name;
  String? displayName;
  DateTime createdAt;
  DateTime updatedAt;

  Bundle({
    required this.id,
    required this.uuid,
    required this.networkCode,
    required this.name,
    this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
        id: json["id"],
        uuid: json["uuid"],
        networkCode: json["networkCode"],
        name: json["name"],
        displayName: json["displayName"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "networkCode": networkCode,
        "name": name,
        "displayName": displayName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class FundingTrigger {
  int id;
  String eocUuid;
  String uuid;
  String fundingRequestUuid;
  String referenceType;
  String referenceUuid;
  DateTime createdAt;
  DateTime updatedAt;

  FundingTrigger({
    required this.id,
    required this.eocUuid,
    required this.uuid,
    required this.fundingRequestUuid,
    required this.referenceType,
    required this.referenceUuid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FundingTrigger.fromJson(Map<String, dynamic> json) => FundingTrigger(
        id: json["id"],
        eocUuid: json["eocUuid"],
        uuid: json["uuid"],
        fundingRequestUuid: json["fundingRequestUuid"],
        referenceType: json["referenceType"],
        referenceUuid: json["referenceUuid"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eocUuid": eocUuid,
        "uuid": uuid,
        "fundingRequestUuid": fundingRequestUuid,
        "referenceType": referenceType,
        "referenceUuid": referenceUuid,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Network {
  int id;
  String code;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  Network({
    required this.id,
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Network.fromJson(Map<String, dynamic> json) => Network(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
