class FetchTaskModel {
  FetchTaskModel({
    required this.milestoneId,
    required this.type,
    required this.taskId,
    required this.episodeId,
  });

  final String milestoneId;
  final String type;
  final String taskId;
  final String episodeId;

  factory FetchTaskModel.fromJson(Map<String, dynamic> json) {
    return FetchTaskModel(
      milestoneId: json["milestoneId"],
      type: json["type"],
      taskId: json["taskId"],
      episodeId: json["episodeId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "taskId": taskId,
        "episodeId": episodeId,
        "milestoneId": milestoneId,
      };
}
