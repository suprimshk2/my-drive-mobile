class Topic {
  final int id;
  final String topic;
  final String patientTopic;
  final int? escalationDays;
  final String? description;
  final String? type;
  final String? createdDate;
  final String? createdBy;
  final String? updatedDate;
  final String? updatedBy;
  final String? status;
  final String? statusUpdatedDate;
  final bool isActive;
  final String uuid;
  final int sequence;

  const Topic({
    required this.id,
    required this.topic,
    required this.patientTopic,
    this.escalationDays,
    this.description,
    this.type,
    required this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.status,
    this.statusUpdatedDate,
    required this.isActive,
    required this.uuid,
    required this.sequence,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      topic: json['topic'],
      patientTopic: json['patientTopic'],
      escalationDays: json['escalationDays'],
      description: json['description'],
      type: json['type'],
      createdDate: json['createdDate'] ?? "",
      createdBy: json['createdBy'],
      updatedDate: json['updatedDate'] ?? "",
      updatedBy: json['updatedBy'],
      status: json['status'],
      statusUpdatedDate: json['statusUpdatedDate'] ?? "",
      isActive: json['isActive'],
      uuid: json['uuid'],
      sequence: json['sequence'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'topic': topic,
        'patientTopic': patientTopic,
        'escalationDays': escalationDays,
        'description': description,
        'type': type,
        'createdDate': createdDate,
        'createdBy': createdBy,
        'updatedDate': updatedDate,
        'updatedBy': updatedBy,
        'status': status,
        'statusUpdatedDate': statusUpdatedDate,
        'isActive': isActive,
        'uuid': uuid,
        'sequence': sequence,
      };
}
