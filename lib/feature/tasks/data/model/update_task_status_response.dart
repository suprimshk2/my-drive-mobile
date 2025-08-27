import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';

class UpdateTaskStatusResponse {
  bool? isUpdated;
  String? taskStatus;
  String? topicStatus;
  String? milestoneStatus;
  String? episodeStatus;
  int? taskId;
  String? type;
  int? episodeId;
  int? milestoneId;
  int? topicId;
  Task? data;

  UpdateTaskStatusResponse({
    this.isUpdated,
    this.taskStatus,
    this.topicStatus,
    this.milestoneStatus,
    this.episodeStatus,
    this.taskId,
    this.type,
    this.episodeId,
    this.milestoneId,
    this.topicId,
    this.data,
  });

  factory UpdateTaskStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTaskStatusResponse(
      isUpdated: json['isUpdated'],
      taskStatus: json['taskStatus'],
      topicStatus: json['topicStatus'],
      milestoneStatus: json['milestoneStatus'],
      episodeStatus: json['episodeStatus'],
      taskId: json['taskId'],
      type: json['type'],
      episodeId: json['episodeId'],
      milestoneId: json['milestoneId'],
      topicId: json['topicId'],
      data: json['data'] != null ? Task.fromJson(json['data']) : null,
    );
  }
}
