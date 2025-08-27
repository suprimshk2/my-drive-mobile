class RequestEocResponseModel {
  final bool? isActive;
  final String? status;
  final int? id;
  final String? eocUuid;
  final String? memberUuid;
  final String? assignTo;
  final String? updatedAt;
  final String? createdAt;
  final String? note;

  RequestEocResponseModel({
    this.isActive,
    this.status,
    this.id,
    this.eocUuid,
    this.memberUuid,
    this.assignTo,
    this.updatedAt,
    this.createdAt,
    this.note,
  });

  factory RequestEocResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestEocResponseModel(
      isActive: json['isActive'] as bool?,
      status: json['status'] as String?,
      id: json['id'] as int?,
      eocUuid: json['eocUuid'] as String?,
      memberUuid: json['memberUuid'] as String?,
      assignTo: json['assignTo'] as String?,
      updatedAt: json['updatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      note: json['note'] as String?,
    );
  }
  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'status': status,
        'id': id,
        'eocUuid': eocUuid,
        'memberUuid': memberUuid,
        'assignTo': assignTo,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
        'note': note,
      };
}
