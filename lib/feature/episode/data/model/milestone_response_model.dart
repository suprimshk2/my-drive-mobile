import 'package:mydrivenepal/shared/shared.dart';

import 'episode_response_model.dart';
import 'model.dart';

class Milestone {
  final int id;
  final int episodeId;
  final String name;
  final int triggerDays;
  final String? triggerPeriod;
  final String? triggerCondition;
  final int? triggerMilestoneId;
  final String description;
  final String? startDate;
  final String? endDate;
  final String? createdDate;
  final String? createdBy;
  final String? updatedDate;
  final String? updatedBy;
  final String? status;
  final String? statusUpdatedDate;
  final String? completedByCcEs;
  final String? completedReason;
  final bool isActive;
  final int sequence;
  final String uuid;
  final String? triggerMilestoneUuid;
  final String? relativeStartDate;
  final String? completionDate;
  final bool isTriggerOnStart;
  final bool isKeyMilestone;
  final bool isMainProcedure;
  final String groupCode;
  final int episode_id;
  final List<Topic> topics;

  const Milestone({
    required this.id,
    required this.episodeId,
    required this.name,
    required this.triggerDays,
    this.triggerPeriod,
    this.triggerCondition,
    this.triggerMilestoneId,
    required this.description,
    this.startDate,
    required this.endDate,
    required this.createdDate,
    required this.createdBy,
    required this.updatedDate,
    required this.updatedBy,
    required this.status,
    required this.statusUpdatedDate,
    required this.completedByCcEs,
    required this.completedReason,
    required this.isActive,
    required this.sequence,
    required this.uuid,
    this.triggerMilestoneUuid,
    required this.relativeStartDate,
    required this.completionDate,
    required this.isTriggerOnStart,
    required this.isKeyMilestone,
    required this.isMainProcedure,
    required this.groupCode,
    required this.episode_id,
    required this.topics,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      episodeId: json['episodeId'] ?? 0,
      name: json['name'],
      triggerDays: json['triggerDays'] ?? 0,
      triggerPeriod: json['triggerPeriod'] ?? "",
      triggerCondition: json['triggerCondition'] ?? "",
      triggerMilestoneId: json['triggerMilestoneId'] ?? 0,
      description: json['description'] ?? "",
      startDate: json['startDate'] ?? "",
      endDate: json['endDate'] ?? "",
      createdDate: json['createdDate'] ?? "",
      createdBy: json['createdBy'] ?? "",
      updatedDate: json['updatedDate'] ?? "",
      updatedBy: json['updatedBy'] ?? "",
      status: json['status'] ?? "",
      statusUpdatedDate: json['statusUpdatedDate'] ?? "",
      completedByCcEs: json['completedByCcEs'] ?? "",
      completedReason: json['completedReason'] ?? "",
      isActive: json['isActive'] ?? false,
      sequence: json['sequence'] ?? 0,
      uuid: json['uuid'] ?? "",
      triggerMilestoneUuid: json['triggerMilestoneUuid'] ?? "",
      relativeStartDate: json['relativeStartDate'] ?? "",
      completionDate: json['completionDate'] ?? "",
      isTriggerOnStart: json['isTriggerOnStart'] ?? false,
      isKeyMilestone: json['isKeyMilestone'] ?? false,
      isMainProcedure: json['isMainProcedure'] ?? false,
      groupCode: json['groupCode'] ?? "",
      episode_id: json['episode_id'] ?? 0,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'episodeId': episodeId,
        'name': name,
        'triggerDays': triggerDays,
        'triggerPeriod': triggerPeriod,
        'triggerCondition': triggerCondition,
        'triggerMilestoneId': triggerMilestoneId,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'createdDate': createdDate,
        'createdBy': createdBy,
        'updatedDate': updatedDate,
        'updatedBy': updatedBy,
        'status': status,
        'statusUpdatedDate': statusUpdatedDate,
        'completedByCcEs': completedByCcEs,
        'completedReason': completedReason,
        'isActive': isActive,
        'sequence': sequence,
        'uuid': uuid,
        'triggerMilestoneUuid': triggerMilestoneUuid,
        'relativeStartDate': relativeStartDate,
        'completionDate': completionDate,
        'isTriggerOnStart': isTriggerOnStart,
        'isKeyMilestone': isKeyMilestone,
        'isMainProcedure': isMainProcedure,
        'groupCode': groupCode,
        'episode_id': episode_id,
        'topics': topics.map((e) => e.toJson()).toList(),
      };
}

class AdaptedMilestone extends Milestone {
  final String? procedureDate;
  final String? episodeOfCare;

  const AdaptedMilestone({
    required super.id,
    required super.episodeId,
    required super.name,
    required super.triggerDays,
    super.triggerPeriod,
    super.triggerCondition,
    super.triggerMilestoneId,
    required super.description,
    super.startDate,
    required super.endDate,
    required super.createdDate,
    required super.createdBy,
    required super.updatedDate,
    required super.updatedBy,
    required super.status,
    required super.statusUpdatedDate,
    required super.completedByCcEs,
    required super.completedReason,
    required super.isActive,
    required super.sequence,
    required super.uuid,
    super.triggerMilestoneUuid,
    required super.relativeStartDate,
    required super.completionDate,
    required super.isTriggerOnStart,
    required super.isKeyMilestone,
    required super.isMainProcedure,
    required super.groupCode,
    required super.episode_id,
    required super.topics,
    this.procedureDate,
    this.episodeOfCare,
  });

  AdaptedMilestone copyWith({
    int? id,
    int? episodeId,
    String? name,
    int? triggerDays,
    String? triggerPeriod,
    String? triggerCondition,
    int? triggerMilestoneId,
    String? description,
    String? startDate,
    String? endDate,
    String? createdDate,
    String? createdBy,
    String? updatedDate,
    String? updatedBy,
    String? status,
    String? statusUpdatedDate,
    String? completedByCcEs,
    String? completedReason,
    bool? isActive,
    int? sequence,
    String? uuid,
    String? triggerMilestoneUuid,
    String? relativeStartDate,
    String? completionDate,
    bool? isTriggerOnStart,
    bool? isKeyMilestone,
    bool? isMainProcedure,
    String? groupCode,
    int? episode_id,
    List<Topic>? topics,
    String? procedureDate,
    String? episodeOfCare,
  }) {
    return AdaptedMilestone(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      name: name ?? this.name,
      triggerDays: triggerDays ?? this.triggerDays,
      triggerPeriod: triggerPeriod ?? this.triggerPeriod,
      triggerCondition: triggerCondition ?? this.triggerCondition,
      triggerMilestoneId: triggerMilestoneId ?? this.triggerMilestoneId,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdDate: createdDate ?? this.createdDate,
      createdBy: createdBy ?? this.createdBy,
      updatedDate: updatedDate ?? this.updatedDate,
      updatedBy: updatedBy ?? this.updatedBy,
      status: status ?? this.status,
      statusUpdatedDate: statusUpdatedDate ?? this.statusUpdatedDate,
      completedByCcEs: completedByCcEs ?? this.completedByCcEs,
      completedReason: completedReason ?? this.completedReason,
      isActive: isActive ?? this.isActive,
      sequence: sequence ?? this.sequence,
      uuid: uuid ?? this.uuid,
      triggerMilestoneUuid: triggerMilestoneUuid ?? this.triggerMilestoneUuid,
      relativeStartDate: relativeStartDate ?? this.relativeStartDate,
      completionDate: completionDate ?? this.completionDate,
      isTriggerOnStart: isTriggerOnStart ?? this.isTriggerOnStart,
      isKeyMilestone: isKeyMilestone ?? this.isKeyMilestone,
      isMainProcedure: isMainProcedure ?? this.isMainProcedure,
      groupCode: groupCode ?? this.groupCode,
      episode_id: episode_id ?? this.episode_id,
      topics: topics ?? this.topics,
      procedureDate: procedureDate ?? this.procedureDate,
      episodeOfCare: episodeOfCare ?? this.episodeOfCare,
    );
  }

  factory AdaptedMilestone.fromJson(Map<String, dynamic> json) {
    final milestone = Milestone.fromJson(json);
    return AdaptedMilestone(
      id: milestone.id,
      episodeId: milestone.episodeId,
      name: milestone.name,
      triggerDays: milestone.triggerDays,
      triggerPeriod: milestone.triggerPeriod,
      triggerCondition: milestone.triggerCondition,
      triggerMilestoneId: milestone.triggerMilestoneId,
      description: milestone.description,
      startDate: formatDateOnly(milestone.startDate ?? ""),
      endDate: formatDateOnly(milestone.endDate ?? ""),
      createdDate: formatDateOnly(milestone.createdDate ?? ""),
      createdBy: milestone.createdBy,
      updatedDate: formatDateOnly(milestone.updatedDate ?? ""),
      updatedBy: milestone.updatedBy,
      status: milestone.status,
      statusUpdatedDate: formatDateOnly(milestone.statusUpdatedDate ?? ""),
      completedByCcEs: milestone.completedByCcEs,
      completedReason: milestone.completedReason,
      isActive: milestone.isActive,
      sequence: milestone.sequence,
      uuid: milestone.uuid,
      triggerMilestoneUuid: milestone.triggerMilestoneUuid,
      relativeStartDate: formatDateOnly(milestone.relativeStartDate ?? ""),
      completionDate: formatDateOnly(milestone.completionDate ?? ""),
      isTriggerOnStart: milestone.isTriggerOnStart,
      isKeyMilestone: milestone.isKeyMilestone,
      isMainProcedure: milestone.isMainProcedure,
      groupCode: milestone.groupCode,
      episode_id: milestone.episode_id,
      topics: milestone.topics,
      procedureDate: (json['procedureDate'] ?? ""),
      episodeOfCare: json['episodeOfCare'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'procedureDate': procedureDate,
        'episodeOfCare': episodeOfCare,
      };
}

class TransformedMilestone extends AdaptedMilestone {
  // Additional transformed properties
  final String formattedStartDate;
  final String formattedCreatedDate;
  final String formattedRelativeStartDate;
  final String formattedProcedureDate;

  const TransformedMilestone({
    // All base properties from AdaptedMilestone
    required super.id,
    required super.episodeId,
    required super.name,
    required super.triggerDays,
    super.triggerPeriod,
    super.triggerCondition,
    super.triggerMilestoneId,
    required super.description,
    super.startDate,
    required super.endDate,
    required super.createdDate,
    required super.createdBy,
    required super.updatedDate,
    required super.updatedBy,
    required super.status,
    required super.statusUpdatedDate,
    required super.completedByCcEs,
    required super.completedReason,
    required super.isActive,
    required super.sequence,
    required super.uuid,
    super.triggerMilestoneUuid,
    required super.relativeStartDate,
    required super.completionDate,
    required super.isTriggerOnStart,
    required super.isKeyMilestone,
    required super.isMainProcedure,
    required super.groupCode,
    required super.episode_id,
    required super.topics,
    super.procedureDate,
    super.episodeOfCare,
    // Additional transformed properties
    required this.formattedStartDate,
    required this.formattedCreatedDate,
    required this.formattedRelativeStartDate,
    required this.formattedProcedureDate,
  });

  // Factory constructor to create from Milestone or AdaptedMilestone
  factory TransformedMilestone.fromMilestone(Milestone milestone) {
    // Convert to AdaptedMilestone if it's not already
    final adaptedMilestone = milestone is AdaptedMilestone
        ? milestone
        : AdaptedMilestone(
            id: milestone.id,
            episodeId: milestone.episodeId,
            name: milestone.name,
            triggerDays: milestone.triggerDays,
            triggerPeriod: milestone.triggerPeriod,
            triggerCondition: milestone.triggerCondition,
            triggerMilestoneId: milestone.triggerMilestoneId,
            description: milestone.description,
            startDate: milestone.startDate,
            endDate: milestone.endDate,
            createdDate: milestone.createdDate,
            createdBy: milestone.createdBy,
            updatedDate: milestone.updatedDate,
            updatedBy: milestone.updatedBy,
            status: milestone.status,
            statusUpdatedDate: milestone.statusUpdatedDate,
            completedByCcEs: milestone.completedByCcEs,
            completedReason: milestone.completedReason,
            isActive: milestone.isActive,
            sequence: milestone.sequence,
            uuid: milestone.uuid,
            triggerMilestoneUuid: milestone.triggerMilestoneUuid,
            relativeStartDate: milestone.relativeStartDate,
            completionDate: milestone.completionDate,
            isTriggerOnStart: milestone.isTriggerOnStart,
            isKeyMilestone: milestone.isKeyMilestone,
            isMainProcedure: milestone.isMainProcedure,
            groupCode: milestone.groupCode,
            episode_id: milestone.episode_id,
            topics: milestone.topics,
            procedureDate: null,
            episodeOfCare: null,
          );

    return TransformedMilestone(
      // Pass all properties from adapted milestone
      id: adaptedMilestone.id,
      episodeId: adaptedMilestone.episodeId,
      name: adaptedMilestone.name,
      triggerDays: adaptedMilestone.triggerDays,
      triggerPeriod: adaptedMilestone.triggerPeriod,
      triggerCondition: adaptedMilestone.triggerCondition,
      triggerMilestoneId: adaptedMilestone.triggerMilestoneId,
      description: adaptedMilestone.description,
      startDate: adaptedMilestone.startDate,
      endDate: adaptedMilestone.endDate,
      createdDate: adaptedMilestone.createdDate,
      createdBy: adaptedMilestone.createdBy,
      updatedDate: adaptedMilestone.updatedDate,
      updatedBy: adaptedMilestone.updatedBy,
      status: adaptedMilestone.status,
      statusUpdatedDate: adaptedMilestone.statusUpdatedDate,
      completedByCcEs: adaptedMilestone.completedByCcEs,
      completedReason: adaptedMilestone.completedReason,
      isActive: adaptedMilestone.isActive,
      sequence: adaptedMilestone.sequence,
      uuid: adaptedMilestone.uuid,
      triggerMilestoneUuid: adaptedMilestone.triggerMilestoneUuid,
      relativeStartDate: adaptedMilestone.relativeStartDate,
      completionDate: adaptedMilestone.completionDate,
      isTriggerOnStart: adaptedMilestone.isTriggerOnStart,
      isKeyMilestone: adaptedMilestone.isKeyMilestone,
      isMainProcedure: adaptedMilestone.isMainProcedure,
      groupCode: adaptedMilestone.groupCode,
      episode_id: adaptedMilestone.episode_id,
      topics: adaptedMilestone.topics,
      procedureDate: adaptedMilestone.procedureDate,
      episodeOfCare: adaptedMilestone.episodeOfCare,
      // Add transformed values
      formattedStartDate: (adaptedMilestone.startDate ?? ''),
      formattedCreatedDate: (adaptedMilestone.createdDate ?? ''),
      formattedRelativeStartDate: (adaptedMilestone.relativeStartDate ?? ""),
      formattedProcedureDate: (adaptedMilestone.procedureDate ?? ''),
    );
  }
}

class TransformedMilestoneItem extends EpisodeItem {
  // Additional transformed properties
  final List<TransformedMilestone> transformedMilestones;
  // final String procedureDate;
  // final String milestoneEpisodeOfCare;

  const TransformedMilestoneItem({
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
    // required this.procedureDate,
    // required this.milestoneEpisodeOfCare,
    required this.transformedMilestones,
  });

  // Factory constructor implementing the transformMilestone logic
  factory TransformedMilestoneItem.transformMilestone(EpisodeItem data) {
    // Transform milestones and sort by sequence
    final transformedMilestones =
        data.milestones.map((AdaptedMilestone milestone) {
      return TransformedMilestone(
        startDate: formatDateOnly(milestone.startDate ?? ""),
        createdDate: formatDateOnly(milestone.createdDate ?? ""),
        relativeStartDate: formatDateOnly(milestone.relativeStartDate ?? ""),
        procedureDate: formatDateOnly(milestone.procedureDate ?? ""),
        sequence: milestone.sequence,
        id: milestone.id,
        episodeId: milestone.episodeId,
        name: milestone.name,
        triggerDays: milestone.triggerDays,
        triggerPeriod: milestone.triggerPeriod,
        triggerCondition: milestone.triggerCondition,
        description: milestone.description,
        endDate: milestone.endDate,
        createdBy: milestone.createdBy,
        updatedDate: milestone.updatedDate,
        status: milestone.status,
        statusUpdatedDate: milestone.statusUpdatedDate,
        completedByCcEs: milestone.completedByCcEs,
        completedReason: milestone.completedReason,
        isActive: milestone.isActive,
        uuid: milestone.uuid,
        completionDate: milestone.completionDate,
        isTriggerOnStart: milestone.isTriggerOnStart,
        isKeyMilestone: milestone.isKeyMilestone,
        isMainProcedure: milestone.isMainProcedure,
        groupCode: milestone.groupCode,
        episode_id: milestone.episode_id,
        topics: milestone.topics,
        // procedureDate:  (milestone.procedureDate ?? ""),
        formattedStartDate: (milestone.startDate ?? ""),
        formattedCreatedDate: (milestone.createdDate ?? ""),
        formattedRelativeStartDate: (milestone.relativeStartDate ?? ""),
        formattedProcedureDate: (milestone.procedureDate ?? ""),
        updatedBy: milestone.updatedBy,
      );
    }).toList()
          ..sort((a, b) => a.sequence.compareTo(b.sequence));

    return TransformedMilestoneItem(
      // Pass all properties from original episode item
      id: data.id,
      name: data.name,
      description: data.description,
      userId: data.userId,
      ccId: data.ccId,
      esId: data.esId,
      facilityId: data.facilityId,
      providerId: data.providerId,
      clinicId: data.clinicId,
      marketCode: data.marketCode,
      networkCode: data.networkCode,
      clientCode: data.clientCode,
      purchaserCode: data.purchaserCode,
      tag: data.tag,
      type: data.type,
      isCancelled: data.isCancelled,
      cancelReason: data.cancelReason,
      isCancelledPriorToProcedure: data.isCancelledPriorToProcedure,
      status: data.status,
      statusUpdatedDate: data.statusUpdatedDate,
      benefitStartDate: data.benefitStartDate,
      benefitEndDate: data.benefitEndDate,
      isSSO: data.isSSO,
      eobDate: data.eobDate,
      endDate: data.endDate,
      patientResponsibility: data.patientResponsibility,
      subscriberNumber: data.subscriberNumber,
      serviceStartDate: data.serviceStartDate,
      serviceEndDate: data.serviceEndDate,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      milestones: data.milestones,
      episodeStatus: data.episodeStatus,
      episodeOfCare: data.episodeOfCare,
      patient: data.patient,
      cc: data.cc,
      es: data.es,
      provider: data.provider,
      facility: data.facility,
      clinic: data.clinic,
      claimPatient: data.claimPatient,
      // Add transformed milestones
      transformedMilestones: transformedMilestones,
      // procedureDate:  (data.milestones.first.procedureDate ?? ""),
      // milestoneEpisodeOfCare: data.episodeOfCare.name,
    );
  }
}
