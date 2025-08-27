class UpdateTaskStatusPayload {
  num? id;
  String? type;
  dynamic messageTitle;
  num? episodeId;
  String? milestoneId;

  UpdateTaskStatusPayload(
      {this.id,
      this.type,
      this.messageTitle,
      this.episodeId,
      this.milestoneId});

  UpdateTaskStatusPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    messageTitle = json['messageTitle'];
    episodeId = json['episodeId'];
    milestoneId = json['milestoneId'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'messageTitle': messageTitle,
        'episodeId': episodeId,
        'milestoneId': milestoneId,
      };
}
