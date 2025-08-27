import 'package:collection/collection.dart';
import 'package:mydrivenepal/shared/shared.dart';

import 'model.dart';

class Cc {
  final int id;
  final String firstName;
  final String lastName;
  final String? memberUuid;

  const Cc({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.memberUuid,
  });

  factory Cc.fromJson(Map<String, dynamic> json) {
    return Cc(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      memberUuid: json['memberUuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'memberUuid': memberUuid,
      };
}

class Es {
  final int id;
  final String firstName;
  final String lastName;
  final String? memberUuid;

  const Es({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.memberUuid,
  });

  factory Es.fromJson(Map<String, dynamic> json) {
    return Es(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      memberUuid: json['memberUuid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'memberUuid': memberUuid,
      };
}

class SupportPersonWithDesignation {
  final int id;
  final String firstName;
  final String lastName;
  final String? memberUuid;
  final String designation;

  const SupportPersonWithDesignation({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.memberUuid,
    required this.designation,
  });
  factory SupportPersonWithDesignation.fromCc(Cc cc) {
    return SupportPersonWithDesignation(
      id: cc.id,
      firstName: cc.firstName,
      lastName: cc.lastName,
      memberUuid: cc.memberUuid,
      designation: 'Care Co-ordinator',
    );
  }

  // Factory constructor from Es
  factory SupportPersonWithDesignation.fromEs(Es es) {
    return SupportPersonWithDesignation(
      id: es.id,
      firstName: es.firstName,
      lastName: es.lastName,
      memberUuid: es.memberUuid,
      designation: 'Engagement Specialist',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'memberUuid': memberUuid,
        'designation': designation,
      };

  String get fullName => '$firstName $lastName';
}

class Bundle {
  final int id;
  final String uuid;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  const Bundle({
    required this.id,
    required this.uuid,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'name': name,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class EpisodeOfCare {
  final int id;
  final String uuid;
  final int episodeId;
  final String networkCode;
  final String name;
  final String? description;
  final String bundleUuid;
  final String pathwayUuid;
  final String eocReferenceUuid;
  final int episode_id;
  final Bundle bundle;

  const EpisodeOfCare({
    required this.id,
    required this.uuid,
    required this.episodeId,
    required this.networkCode,
    required this.name,
    this.description,
    required this.bundleUuid,
    required this.pathwayUuid,
    required this.eocReferenceUuid,
    required this.episode_id,
    required this.bundle,
  });

  factory EpisodeOfCare.fromJson(Map<String, dynamic> json) {
    return EpisodeOfCare(
      id: json['id'],
      uuid: json['uuid'],
      episodeId: json['episodeId'],
      networkCode: json['networkCode'],
      name: json['name'],
      description: json['description'],
      bundleUuid: json['bundleUuid'],
      pathwayUuid: json['pathwayUuid'],
      eocReferenceUuid: json['eocReferenceUuid'],
      episode_id: json['episode_id'],
      bundle: Bundle.fromJson(json['bundle']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'episodeId': episodeId,
        'networkCode': networkCode,
        'name': name,
        'description': description,
        'bundleUuid': bundleUuid,
        'pathwayUuid': pathwayUuid,
        'eocReferenceUuid': eocReferenceUuid,
        'episode_id': episode_id,
        'bundle': bundle.toJson(),
      };
}

class EpisodeStatus {
  final int id;
  final int episodeId;
  final String initialStatus;
  final String finalStatus;
  final String? createdAt;

  const EpisodeStatus({
    required this.id,
    required this.episodeId,
    required this.initialStatus,
    required this.finalStatus,
    required this.createdAt,
  });

  factory EpisodeStatus.fromJson(Map<String, dynamic> json) {
    return EpisodeStatus(
      id: json['id'],
      episodeId: json['episodeId'] ?? 0,
      initialStatus: json['initialStatus'] ?? "",
      finalStatus: json['finalStatus'] ?? "",
      createdAt: json['createdAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'episodeId': episodeId,
        'initialStatus': initialStatus,
        'finalStatus': finalStatus,
        'createdAt': createdAt,
      };
}

class Facility {
  final String entityCode;
  final int id;
  final String name;
  final List<String> networkCode;
  final String npi;
  final String providerId;

  const Facility({
    required this.entityCode,
    required this.id,
    required this.name,
    required this.networkCode,
    required this.npi,
    required this.providerId,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      entityCode: json['entityCode'],
      id: json['id'],
      name: json['name'],
      networkCode: List<String>.from(json['networkCode']),
      npi: json['npi'],
      providerId: json['providerId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'entityCode': entityCode,
        'id': id,
        'name': name,
        'networkCode': networkCode,
        'npi': npi,
        'providerId': providerId,
      };
}

class Clinic {
  final int id;
  final String providerId;
  final String name;
  final String npi;
  final String entityCode;
  final List<String> networkCode;

  const Clinic({
    required this.id,
    required this.providerId,
    required this.name,
    required this.npi,
    required this.entityCode,
    required this.networkCode,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      providerId: json['providerId'],
      name: json['name'],
      npi: json['npi'],
      entityCode: json['entityCode'],
      networkCode: List<String>.from(json['networkCode']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'providerId': providerId,
        'name': name,
        'npi': npi,
        'entityCode': entityCode,
        'networkCode': networkCode,
      };
}

class Provider {
  final int id;
  final String providerId;
  final String name;
  final String npi;
  final String entityCode;
  final List<String> networkCode;

  const Provider({
    required this.id,
    required this.providerId,
    required this.name,
    required this.npi,
    required this.entityCode,
    required this.networkCode,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      providerId: json['providerId'],
      name: json['name'],
      npi: json['npi'],
      entityCode: json['entityCode'],
      networkCode: List<String>.from(json['networkCode']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'providerId': providerId,
        'name': name,
        'npi': npi,
        'entityCode': entityCode,
        'networkCode': networkCode,
      };
}

class BenefitPeriod {
  final String benefitEndDate;
  final String benefitStartDate;

  const BenefitPeriod({
    required this.benefitEndDate,
    required this.benefitStartDate,
  });

  factory BenefitPeriod.fromJson(Map<String, dynamic> json) {
    return BenefitPeriod(
      benefitEndDate: json['benefitEndDate'],
      benefitStartDate: json['benefitStartDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'benefitEndDate': benefitEndDate,
        'benefitStartDate': benefitStartDate,
      };
}

class EpisodeItem {
  final int id;
  final String name;
  final String? description;
  final int userId;
  final int ccId;
  final int esId;
  final String facilityId;
  final int? providerId;
  final int? clinicId;
  final String marketCode;
  final String networkCode;
  final String clientCode;
  final String purchaserCode;
  final String? tag;
  final String? type;
  final bool isCancelled;
  final String? cancelReason;
  final bool isCancelledPriorToProcedure;
  final String status;
  final String statusUpdatedDate;
  final String benefitStartDate;
  final String benefitEndDate;
  final bool isSSO;
  final String? eobDate;
  final String? endDate;
  final String patientResponsibility;
  final String? subscriberNumber;
  final String? serviceStartDate;
  final String? serviceEndDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AdaptedMilestone> milestones;
  final List<EpisodeStatus> episodeStatus;
  final EpisodeOfCare episodeOfCare;
  final Cc patient;
  final Cc? cc;
  final Es? es;
  final Provider? provider;
  final Facility facility;
  final Clinic? clinic;
  final dynamic claimPatient;

  const EpisodeItem({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.ccId,
    required this.esId,
    required this.facilityId,
    this.providerId,
    this.clinicId,
    required this.marketCode,
    required this.networkCode,
    required this.clientCode,
    required this.purchaserCode,
    this.tag,
    this.type,
    required this.isCancelled,
    this.cancelReason,
    required this.isCancelledPriorToProcedure,
    required this.status,
    required this.statusUpdatedDate,
    required this.benefitStartDate,
    required this.benefitEndDate,
    required this.isSSO,
    this.eobDate,
    this.endDate,
    required this.patientResponsibility,
    this.subscriberNumber,
    this.serviceStartDate,
    this.serviceEndDate,
    this.createdAt,
    this.updatedAt,
    required this.milestones,
    required this.episodeStatus,
    required this.episodeOfCare,
    required this.patient,
    this.cc,
    this.es,
    this.provider,
    required this.facility,
    this.clinic,
    this.claimPatient,
  });

  factory EpisodeItem.fromJson(Map<String, dynamic> json) {
    return EpisodeItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      userId: json['userId'],
      ccId: json['ccId'],
      esId: json['esId'],
      facilityId: json['facilityId'],
      providerId: json['providerId'],
      clinicId: json['clinicId'],
      marketCode: json['marketCode'],
      networkCode: json['networkCode'],
      clientCode: json['clientCode'],
      purchaserCode: json['purchaserCode'],
      tag: json['tag'],
      type: json['type'],
      isCancelled: json['isCancelled'],
      cancelReason: json['cancelReason'],
      isCancelledPriorToProcedure: json['isCancelledPriorToProcedure'] ?? false,
      status: json['status'],
      statusUpdatedDate: json['statusUpdatedDate'] ?? "",
      benefitStartDate: json['benefitStartDate'] ?? "",
      benefitEndDate: json['benefitEndDate'] ?? "",
      isSSO: json['isSSO'],
      eobDate: json['eobDate'] ?? "",
      endDate: json['endDate'] ?? "",
      patientResponsibility: json['patientResponsibility'] ?? "",
      subscriberNumber: json['subscriberNumber'],
      serviceStartDate: json['serviceStartDate'],
      serviceEndDate: json['serviceEndDate'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => AdaptedMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      episodeStatus: (json['episodeStatus'] as List<dynamic>)
          .map((e) => EpisodeStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      episodeOfCare: EpisodeOfCare.fromJson(json['episodeOfCare']),
      patient: Cc.fromJson(json['patient']),
      cc: json['cc'] != null ? Cc.fromJson(json['cc']) : null,
      es: json['es'] != null ? Es.fromJson(json['es']) : null,
      provider:
          json['provider'] != null ? Provider.fromJson(json['provider']) : null,
      facility: Facility.fromJson(json['facility']),
      clinic: json['clinic'] != null ? Clinic.fromJson(json['clinic']) : null,
      claimPatient: json['claimPatient'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'userId': userId,
        'ccId': ccId,
        'esId': esId,
        'facilityId': facilityId,
        'providerId': providerId,
        'clinicId': clinicId,
        'marketCode': marketCode,
        'networkCode': networkCode,
        'clientCode': clientCode,
        'purchaserCode': purchaserCode,
        'tag': tag,
        'type': type,
        'isCancelled': isCancelled,
        'cancelReason': cancelReason,
        'isCancelledPriorToProcedure': isCancelledPriorToProcedure,
        'status': status,
        'statusUpdatedDate': statusUpdatedDate,
        'benefitStartDate': benefitStartDate,
        'benefitEndDate': benefitEndDate,
        'isSSO': isSSO,
        'eobDate': eobDate,
        'endDate': endDate,
        'patientResponsibility': patientResponsibility,
        'subscriberNumber': subscriberNumber,
        'serviceStartDate': serviceStartDate,
        'serviceEndDate': serviceEndDate,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'milestones': milestones.map((e) => e.toJson()).toList(),
        'episodeStatus': episodeStatus.map((e) => e.toJson()).toList(),
        'episodeOfCare': episodeOfCare.toJson(),
        'patient': patient.toJson(),
        'cc': cc?.toJson(),
        'es': es?.toJson(),
        'provider': provider?.toJson(),
        'facility': facility.toJson(),
        'clinic': clinic?.toJson(),
        'claimPatient': claimPatient,
      };

  static List<EpisodeItem> fromJsonList(dynamic json) =>
      List<EpisodeItem>.from(json.map((x) => EpisodeItem.fromJson(x)));
}

class TransformedEpisodeItem extends EpisodeItem {
  // Additional transformed properties
  final List<TransformedMilestone> transformedMilestones;

  const TransformedEpisodeItem({
    // All base properties from EpisodeItem
    required super.id,
    required super.name,
    super.description,
    required super.userId,
    required super.ccId,
    required super.esId,
    required super.facilityId,
    super.providerId,
    super.clinicId,
    required super.marketCode,
    required super.networkCode,
    required super.clientCode,
    required super.purchaserCode,
    super.tag,
    super.type,
    required super.isCancelled,
    super.cancelReason,
    required super.isCancelledPriorToProcedure,
    required super.status,
    required super.statusUpdatedDate,
    required super.benefitStartDate,
    required super.benefitEndDate,
    required super.isSSO,
    super.eobDate,
    super.endDate,
    required super.patientResponsibility,
    super.subscriberNumber,
    super.serviceStartDate,
    super.serviceEndDate,
    required super.createdAt,
    required super.updatedAt,
    required super.milestones,
    required super.episodeStatus,
    required super.episodeOfCare,
    required super.patient,
    required super.cc,
    required super.es,
    super.provider,
    required super.facility,
    super.clinic,
    super.claimPatient,
    // Additional transformed property
    required this.transformedMilestones,
  });

//   // Factory constructor implementing the transformMilestone logic
//   factory TransformedEpisodeItem.transformMilestone(EpisodeItem data) {
//     // Transform milestones and sort by sequence
//     final transformedMilestones = data.milestones
//         .map((milestone) => TransformedMilestone.fromMilestone(milestone))
//         .toList()
//       ..sort((a, b) => a.sequence.compareTo(b.sequence));

//     return TransformedEpisodeItem(
//       // Pass all properties from original episode item
//       id: data.id,
//       name: data.name,
//       description: data.description,
//       userId: data.userId,
//       ccId: data.ccId,
//       esId: data.esId,
//       facilityId: data.facilityId,
//       providerId: data.providerId,
//       clinicId: data.clinicId,
//       marketCode: data.marketCode,
//       networkCode: data.networkCode,
//       clientCode: data.clientCode,
//       purchaserCode: data.purchaserCode,
//       tag: data.tag,
//       type: data.type,
//       isCancelled: data.isCancelled,
//       cancelReason: data.cancelReason,
//       isCancelledPriorToProcedure: data.isCancelledPriorToProcedure,
//       status: data.status,
//       statusUpdatedDate: data.statusUpdatedDate,
//       benefitStartDate: data.benefitStartDate,
//       benefitEndDate: data.benefitEndDate,
//       isSSO: data.isSSO,
//       eobDate: data.eobDate,
//       endDate: data.endDate,
//       patientResponsibility: data.patientResponsibility,
//       subscriberNumber: data.subscriberNumber,
//       serviceStartDate: data.serviceStartDate,
//       serviceEndDate: data.serviceEndDate,
//       createdAt: data.createdAt,
//       updatedAt: data.updatedAt,
//       milestones: data.milestones,
//       episodeStatus: data.episodeStatus,
//       episodeOfCare: data.episodeOfCare,
//       patient: data.patient,
//       cc: data.cc,
//       es: data.es,
//       provider: data.provider,
//       facility: data.facility,
//       clinic: data.clinic,
//       claimPatient: data.claimPatient,
//       // Add transformed milestones
//       transformedMilestones: transformedMilestones,
//     );
//   }
}

// models/transformed_episode.dart
class TransformedEpisode extends EpisodeItem {
  // Additional transformed properties
  final String procedureDate;
  final String formattedStartDate;
  final String episodeOfCareName;

  const TransformedEpisode({
    // All base properties from EpisodeItem
    required super.id,
    required super.name,
    super.description,
    required super.userId,
    required super.ccId,
    required super.esId,
    required super.facilityId,
    super.providerId,
    super.clinicId,
    required super.marketCode,
    required super.networkCode,
    required super.clientCode,
    required super.purchaserCode,
    super.tag,
    super.type,
    required super.isCancelled,
    super.cancelReason,
    required super.isCancelledPriorToProcedure,
    required super.status,
    required super.statusUpdatedDate,
    required super.benefitStartDate,
    required super.benefitEndDate,
    required super.isSSO,
    super.eobDate,
    super.endDate,
    required super.patientResponsibility,
    super.subscriberNumber,
    super.serviceStartDate,
    super.serviceEndDate,
    required super.createdAt,
    required super.updatedAt,
    required super.milestones,
    required super.episodeStatus,
    required super.episodeOfCare,
    required super.patient,
    required super.cc,
    required super.es,
    super.provider,
    required super.facility,
    super.clinic,
    super.claimPatient,
    // Additional transformed properties
    required this.procedureDate,
    required this.formattedStartDate,
    required this.episodeOfCareName,
  });

  TransformedEpisode copyWith({
    String? status,
    int? id,
    String? name,
    String? description,
    int? userId,
    int? ccId,
    int? esId,
    String? facilityId,
    int? providerId,
    int? clinicId,
    String? marketCode,
    String? networkCode,
    String? clientCode,
    String? purchaserCode,
    String? tag,
    String? type,
    bool? isCancelled,
    String? cancelReason,
    bool? isCancelledPriorToProcedure,
    String? statusUpdatedDate,
    String? benefitStartDate,
    String? benefitEndDate,
    bool? isSSO,
    String? eobDate,
    String? endDate,
    String? patientResponsibility,
    String? subscriberNumber,
    String? serviceStartDate,
    String? serviceEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AdaptedMilestone>? milestones,
    List<EpisodeStatus>? episodeStatus,
    EpisodeOfCare? episodeOfCare,
    Cc? patient,
    Cc? cc,
    Es? es,
    Provider? provider,
    Facility? facility,
    Clinic? clinic,
    dynamic claimPatient,
    String? procedureDate,
    String? formattedStartDate,
    String? episodeOfCareName,
  }) {
    return TransformedEpisode(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      ccId: ccId ?? this.ccId,
      esId: esId ?? this.esId,
      facilityId: facilityId ?? this.facilityId,
      providerId: providerId ?? this.providerId,
      clinicId: clinicId ?? this.clinicId,
      marketCode: marketCode ?? this.marketCode,
      networkCode: networkCode ?? this.networkCode,
      clientCode: clientCode ?? this.clientCode,
      purchaserCode: purchaserCode ?? this.purchaserCode,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      isCancelled: isCancelled ?? this.isCancelled,
      cancelReason: cancelReason ?? this.cancelReason,
      isCancelledPriorToProcedure:
          isCancelledPriorToProcedure ?? this.isCancelledPriorToProcedure,
      status: status ?? this.status,
      statusUpdatedDate: statusUpdatedDate ?? this.statusUpdatedDate,
      benefitStartDate: benefitStartDate ?? this.benefitStartDate,
      benefitEndDate: benefitEndDate ?? this.benefitEndDate,
      isSSO: isSSO ?? this.isSSO,
      eobDate: eobDate ?? this.eobDate,
      endDate: endDate ?? this.endDate,
      patientResponsibility:
          patientResponsibility ?? this.patientResponsibility,
      subscriberNumber: subscriberNumber ?? this.subscriberNumber,
      serviceStartDate: serviceStartDate ?? this.serviceStartDate,
      serviceEndDate: serviceEndDate ?? this.serviceEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      milestones: milestones ?? this.milestones,
      episodeStatus: episodeStatus ?? this.episodeStatus,
      episodeOfCare: episodeOfCare ?? this.episodeOfCare,
      patient: patient ?? this.patient,
      cc: cc ?? this.cc,
      es: es ?? this.es,
      provider: provider ?? this.provider,
      facility: facility ?? this.facility,
      clinic: clinic ?? this.clinic,
      claimPatient: claimPatient ?? this.claimPatient,
      procedureDate: procedureDate ?? this.procedureDate,
      formattedStartDate: formattedStartDate ?? this.formattedStartDate,
      episodeOfCareName: episodeOfCareName ?? this.episodeOfCareName,
    );
  }

  // Factory constructor to create from EpisodeItem
  factory TransformedEpisode.transformEpisodes(EpisodeItem episode) {
    final mainProcedure =
        episode.milestones.cast<Milestone?>().firstWhereOrNull(
              (m) => m?.isMainProcedure ?? false,
            );

    final procedureDate = (mainProcedure?.startDate ?? '');
    final episodeOfCare = episode.episodeOfCare.name;
    final startDate = mainProcedure?.startDate != null
        ? (mainProcedure?.startDate ?? '')
        : 'N/A';

    return TransformedEpisode(
      // Pass all properties from original episode
      id: episode.id,
      name: episode.name,
      description: episode.description,
      userId: episode.userId,
      ccId: episode.ccId,
      esId: episode.esId,
      facilityId: episode.facilityId,
      providerId: episode.providerId,
      clinicId: episode.clinicId,
      marketCode: episode.marketCode,
      networkCode: episode.networkCode,
      clientCode: episode.clientCode,
      purchaserCode: episode.purchaserCode,
      tag: episode.tag,
      type: episode.type,
      isCancelled: episode.isCancelled,
      cancelReason: episode.cancelReason,
      isCancelledPriorToProcedure: episode.isCancelledPriorToProcedure,
      status: episode.status,
      statusUpdatedDate: episode.statusUpdatedDate,
      benefitStartDate: episode.benefitStartDate,
      benefitEndDate: episode.benefitEndDate,
      isSSO: episode.isSSO,
      eobDate: episode.eobDate,
      endDate: episode.endDate,
      patientResponsibility: episode.patientResponsibility,
      subscriberNumber: episode.subscriberNumber,
      serviceStartDate: episode.serviceStartDate,
      serviceEndDate: episode.serviceEndDate,
      createdAt: episode.createdAt,
      updatedAt: episode.updatedAt,
      patient: episode.patient,
      cc: episode.cc,
      es: episode.es,
      provider: episode.provider,
      facility: episode.facility,
      clinic: episode.clinic,
      claimPatient: episode.claimPatient,
      episodeOfCare: episode.episodeOfCare,
      milestones: episode.milestones,
      episodeStatus: episode.episodeStatus,
      // Add transformed values
      procedureDate: procedureDate,
      formattedStartDate: startDate,
      episodeOfCareName: episodeOfCare,
    );
  }

  static List<TransformedEpisode> filterActiveEpisode(List<EpisodeItem> data) {
    return data
        .where((episode) => episode.status == 'CONFIRMED')
        .map((episode) {
      final mainProcedure = episode.milestones
          .cast<Milestone?>()
          .firstWhere((m) => m?.isMainProcedure ?? false, orElse: () => null);

      final procedureDate = (mainProcedure?.startDate ?? '');
      final episodeOfCareName = episode.episodeOfCare.bundle.name;
      final startDate = mainProcedure?.startDate != null
          ? formatDateOnly(mainProcedure?.startDate ?? '')
          : 'N/A';

      return TransformedEpisode(
        id: episode.id,
        name: episode.name,
        description: episode.description,
        userId: episode.userId,
        ccId: episode.ccId,
        esId: episode.esId,
        facilityId: episode.facilityId,
        providerId: episode.providerId,
        clinicId: episode.clinicId,
        marketCode: episode.marketCode,
        networkCode: episode.networkCode,
        clientCode: episode.clientCode,
        purchaserCode: episode.purchaserCode,
        tag: episode.tag,
        type: episode.type,
        isCancelled: episode.isCancelled,
        cancelReason: episode.cancelReason,
        isCancelledPriorToProcedure: episode.isCancelledPriorToProcedure,
        status: episode.status,
        statusUpdatedDate: episode.statusUpdatedDate,
        benefitStartDate: episode.benefitStartDate,
        benefitEndDate: episode.benefitEndDate,
        isSSO: episode.isSSO,
        eobDate: episode.eobDate,
        endDate: episode.endDate,
        patientResponsibility: episode.patientResponsibility,
        subscriberNumber: episode.subscriberNumber,
        serviceStartDate: episode.serviceStartDate,
        serviceEndDate: episode.serviceEndDate,
        createdAt: episode.createdAt,
        updatedAt: episode.updatedAt,
        patient: episode.patient,
        cc: episode.cc,
        es: episode.es,
        provider: episode.provider,
        facility: episode.facility,
        clinic: episode.clinic,
        claimPatient: episode.claimPatient,
        episodeOfCare: episode.episodeOfCare,
        milestones: episode.milestones,
        episodeStatus: episode.episodeStatus,
        procedureDate: procedureDate,
        formattedStartDate: startDate,
        episodeOfCareName: episodeOfCareName,
      );
    }).toList();
  }
}
