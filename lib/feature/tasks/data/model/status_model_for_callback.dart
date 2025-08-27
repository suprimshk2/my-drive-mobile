class StatusModelForCallback {
  final num taskId;
  final String taskStatus;

  final num topicId;
  final String topicStatus;

  final num milestoneId;
  final String milestoneStatus;

  final int episodeId;
  final String episodeStatus;

  // final List<AnswerOption> answerOptions;

  StatusModelForCallback({
    required this.taskId,
    required this.taskStatus,
    required this.topicId,
    required this.topicStatus,
    required this.milestoneId,
    required this.milestoneStatus,
    required this.episodeId,
    required this.episodeStatus,
    // required this.answerOptions,
  });
}
