class QuestionTaskPayload {
  QuestionTaskPayload({
    required this.answers,
    required this.type,
    required this.taskId,
    required this.episodeId,
    required this.milestoneId,
    required this.topicId,
    required this.taskName,
  });

  final List<Answer> answers;
  final String? type;
  final num? taskId;
  final num? episodeId;
  final num? milestoneId;
  final num? topicId;
  final String? taskName;

  factory QuestionTaskPayload.fromJson(Map<String, dynamic> json) {
    return QuestionTaskPayload(
      answers: json["answers"] == null
          ? []
          : List<Answer>.from(json["answers"]!.map((x) => Answer.fromJson(x))),
      type: json["type"],
      taskId: json["taskId"],
      episodeId: json["episodeId"],
      milestoneId: json["milestoneId"],
      topicId: json["topicId"],
      taskName: json["taskName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "answers": answers.map((x) => x.toJson()).toList(),
        "type": type,
        "taskId": taskId,
        "episodeId": episodeId,
        "milestoneId": milestoneId,
        "topicId": topicId,
        "taskName": taskName,
      };
}

class Answer {
  Answer({
    required this.episodeId,
    required this.milestoneId,
    required this.topicId,
    required this.taskId,
    required this.questionId,
    required this.userId,
    required this.isDependent,
    required this.taskType,
    required this.dependentOptionId,
    required this.questionType,
    required this.answer,
    required this.questionName,
    required this.answerOptionId,
  });

  final num? episodeId;
  final num? milestoneId;
  final num? topicId;
  final num? taskId;
  final num? questionId;
  final num? userId;
  final bool? isDependent;
  final String? taskType;
  final dynamic dependentOptionId;
  final String? questionType;
  final dynamic answer;
  final String? questionName;
  final List<num> answerOptionId;

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      episodeId: json["episodeId"],
      milestoneId: json["milestoneId"],
      topicId: json["topicId"],
      taskId: json["taskId"],
      questionId: json["questionId"],
      userId: json["userId"],
      isDependent: json["isDependent"],
      taskType: json["taskType"],
      dependentOptionId: json["dependentOptionId"],
      questionType: json["questionType"],
      answer: json["answer"],
      questionName: json["questionName"],
      answerOptionId: json["answerOptionId"] == null
          ? []
          : List<num>.from(json["answerOptionId"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "episodeId": episodeId,
        "milestoneId": milestoneId,
        "topicId": topicId,
        "taskId": taskId,
        "questionId": questionId,
        "userId": userId,
        "isDependent": isDependent,
        "taskType": taskType,
        "dependentOptionId": dependentOptionId,
        "questionType": questionType,
        "answer": answer,
        "questionName": questionName,
        "answerOptionId": answerOptionId.map((x) => x).toList(),
      };
}
