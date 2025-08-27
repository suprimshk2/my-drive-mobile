import '../../../../shared/shared.dart';

class IdCardResponseModel {
  int id;
  String clientCode;
  String groupName;
  dynamic groupId;
  String benefitPlan;
  dynamic planCode;
  String episodeTypeText;
  String episodeBenefitDateText;
  String claimContactText;
  String claimContactNumber;
  String customerContactText;
  String customerContactNumber;
  String clearingHouseText;
  String clearingHouseName;
  String submitClaimText;
  String payerText;
  String payerId;
  String pwpText;
  String pwpLink;
  String logo;
  dynamic secondaryLogo;
  dynamic copayText;
  DateTime createdAt;
  DateTime updatedAt;
  List<BenefitDetailModel> benefitDetails;
  ClientModel client;
  MemberModel member;

  IdCardResponseModel({
    required this.id,
    required this.clientCode,
    required this.groupName,
    required this.groupId,
    required this.benefitPlan,
    required this.planCode,
    required this.episodeTypeText,
    required this.episodeBenefitDateText,
    required this.claimContactText,
    required this.claimContactNumber,
    required this.customerContactText,
    required this.customerContactNumber,
    required this.clearingHouseText,
    required this.clearingHouseName,
    required this.submitClaimText,
    required this.payerText,
    required this.payerId,
    required this.pwpText,
    required this.pwpLink,
    required this.logo,
    required this.secondaryLogo,
    required this.copayText,
    required this.createdAt,
    required this.updatedAt,
    required this.benefitDetails,
    required this.client,
    required this.member,
  });

  factory IdCardResponseModel.fromJson(Map<String, dynamic> json) =>
      IdCardResponseModel(
        id: json["id"],
        clientCode: json["clientCode"],
        groupName: json["groupName"],
        groupId: json["groupId"],
        benefitPlan: json["benefitPlan"],
        planCode: json["planCode"],
        episodeTypeText: json["episodeTypeText"],
        episodeBenefitDateText: json["episodeBenefitDateText"],
        claimContactText: json["claimContactText"],
        claimContactNumber: json["claimContactNumber"],
        customerContactText: json["customerContactText"],
        customerContactNumber: json["customerContactNumber"],
        clearingHouseText: json["clearingHouseText"],
        clearingHouseName: json["clearingHouseName"],
        submitClaimText: json["submitClaimText"],
        payerText: json["payerText"],
        payerId: json["payerId"],
        pwpText: json["pwpText"],
        pwpLink: json["pwpLink"],
        logo: json["logo"],
        secondaryLogo: json["secondaryLogo"],
        copayText: json["copayText"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        benefitDetails: List<BenefitDetailModel>.from(
            json["benefitDetails"].map((x) => BenefitDetailModel.fromJson(x))),
        client: ClientModel.fromJson(json["client"]),
        member: MemberModel.fromJson(json["member"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clientCode": clientCode,
        "groupName": groupName,
        "groupId": groupId,
        "benefitPlan": benefitPlan,
        "planCode": planCode,
        "episodeTypeText": episodeTypeText,
        "episodeBenefitDateText": episodeBenefitDateText,
        "claimContactText": claimContactText,
        "claimContactNumber": claimContactNumber,
        "customerContactText": customerContactText,
        "customerContactNumber": customerContactNumber,
        "clearingHouseText": clearingHouseText,
        "clearingHouseName": clearingHouseName,
        "submitClaimText": submitClaimText,
        "payerText": payerText,
        "payerId": payerId,
        "pwpText": pwpText,
        "pwpLink": pwpLink,
        "logo": logo,
        "secondaryLogo": secondaryLogo,
        "copayText": copayText,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "benefitDetails":
            List<dynamic>.from(benefitDetails.map((x) => x.toJson())),
        "client": client.toJson(),
        "member": member.toJson(),
      };

  static List<IdCardResponseModel> fromJsonList(dynamic json) =>
      List<IdCardResponseModel>.from(
          json.map((x) => IdCardResponseModel.fromJson(x)));

  // Helper getters for data mapping / formatting
  String get memberFullName => '${member.firstName} ${member.lastName}';

  String get formattedDob => formatRegisterDate(member.dob.toString());

  String get groupIdString => groupId?.toString() ?? '';

  String get planCodeString => planCode?.toString() ?? '';

  String get copayTextString => copayText?.toString() ?? '';

  String get formattedClaimContactNumber =>
      formatPhoneNumber(claimContactNumber);

  String get formattedCustomerContactNumber =>
      formatPhoneNumber(customerContactNumber);
}

class BenefitDetailModel {
  int id;
  String name;
  dynamic tag;
  dynamic benefitStartDate;
  dynamic benefitEndDate;
  String clientCode;
  int userId;
  String purchaserCode;
  EpisodeOfCareModel episodeOfCare;
  String episodeType;
  String benefitDates;
  String episodeCoverageDates;

  BenefitDetailModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.benefitStartDate,
    required this.benefitEndDate,
    required this.clientCode,
    required this.userId,
    required this.purchaserCode,
    required this.episodeOfCare,
    required this.episodeType,
    required this.benefitDates,
    required this.episodeCoverageDates,
  });

  factory BenefitDetailModel.fromJson(Map<String, dynamic> json) =>
      BenefitDetailModel(
        id: json["id"],
        name: json["name"],
        tag: json["tag"],
        benefitStartDate: json["benefitStartDate"],
        benefitEndDate: json["benefitEndDate"],
        clientCode: json["clientCode"],
        userId: json["userId"],
        purchaserCode: json["purchaserCode"],
        episodeOfCare: EpisodeOfCareModel.fromJson(json["episodeOfCare"]),
        episodeType: json["episodeType"],
        benefitDates: json["benefitDates"],
        episodeCoverageDates: json["episodeCoverageDates"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
        "benefitStartDate": benefitStartDate,
        "benefitEndDate": benefitEndDate,
        "clientCode": clientCode,
        "userId": userId,
        "purchaserCode": purchaserCode,
        "episodeOfCare": episodeOfCare.toJson(),
        "episodeType": episodeType,
        "benefitDates": benefitDates,
        "episodeCoverageDates": episodeCoverageDates,
      };
}

class EpisodeOfCareModel {
  String bundleUuid;

  EpisodeOfCareModel({
    required this.bundleUuid,
  });

  factory EpisodeOfCareModel.fromJson(Map<String, dynamic> json) =>
      EpisodeOfCareModel(
        bundleUuid: json["bundleUuid"],
      );

  Map<String, dynamic> toJson() => {
        "bundleUuid": bundleUuid,
      };
}

class ClientModel {
  int id;
  String code;
  String name;
  dynamic logo;
  DateTime createdAt;
  List<NetworkModel> networks;

  ClientModel({
    required this.id,
    required this.code,
    required this.name,
    required this.logo,
    required this.createdAt,
    required this.networks,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        logo: json["logo"],
        createdAt: DateTime.parse(json["createdAt"]),
        networks: List<NetworkModel>.from(
            json["networks"].map((x) => NetworkModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "logo": logo,
        "createdAt": createdAt.toIso8601String(),
        "networks": List<dynamic>.from(networks.map((x) => x.toJson())),
      };
}

class NetworkModel {
  int id;
  String code;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  NetworkModel({
    required this.id,
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
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
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class MemberModel {
  int id;
  String firstName;
  String lastName;
  String memberUuid;
  DateTime dob;
  String subscriberNumber;
  DateTime createdAt;
  List<String> subscriberNumbers;
  List<String> purchaserNames;
  bool isMfaEnabled;

  MemberModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.memberUuid,
    required this.dob,
    required this.subscriberNumber,
    required this.createdAt,
    required this.subscriberNumbers,
    required this.purchaserNames,
    required this.isMfaEnabled,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        memberUuid: json["memberUuid"],
        dob: DateTime.parse(json["dob"]),
        subscriberNumber: json["subscriberNumber"],
        createdAt: DateTime.parse(json["createdAt"]),
        subscriberNumbers:
            List<String>.from(json["subscriberNumbers"].map((x) => x)),
        purchaserNames: List<String>.from(json["purchaserNames"].map((x) => x)),
        isMfaEnabled: json["isMfaEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "memberUuid": memberUuid,
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "subscriberNumber": subscriberNumber,
        "createdAt": createdAt.toIso8601String(),
        "subscriberNumbers":
            List<dynamic>.from(subscriberNumbers.map((x) => x)),
        "purchaserNames": List<dynamic>.from(purchaserNames.map((x) => x)),
        "isMfaEnabled": isMfaEnabled,
      };
}
