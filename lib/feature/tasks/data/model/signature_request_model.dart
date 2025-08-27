class SignatureRequestModel {
  SignatureRequestModel({
    required this.topicId,
    required this.taskTodoId,
    required this.episodeId,
  });

  final String topicId;
  final String taskTodoId;
  final String episodeId;

  factory SignatureRequestModel.fromJson(Map<String, dynamic> json) {
    return SignatureRequestModel(
      topicId: json["topicId"],
      taskTodoId: json["taskTodoId"],
      episodeId: json["episodeId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "topicId": topicId,
        "taskId": taskTodoId,
        "episodeId": episodeId,
      };
}
