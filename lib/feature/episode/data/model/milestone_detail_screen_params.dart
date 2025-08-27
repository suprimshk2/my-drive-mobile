import 'package:mydrivenepal/feature/episode/data/model/topic_response_model.dart';

class MilestoneDetailScreenParams {
  final int episodeId;
  final String name;
  final String description;
  final List<Topic> topics;
  final int milestoneId;
  final String? startDate;
  final String? relativeStartDate;
  final String? procedureDate;
  MilestoneDetailScreenParams({
    required this.episodeId,
    required this.name,
    required this.description,
    required this.topics,
    required this.milestoneId,
    this.startDate,
    this.relativeStartDate,
    this.procedureDate,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'episodeId': episodeId,
      'name': name,
      'description': description,
      'topics': topics,
      'milestoneId': milestoneId,
      'startDate': startDate,
      'relativeStartDate': relativeStartDate,
      'procedureDate': procedureDate,
    };
  }

  factory MilestoneDetailScreenParams.fromJson(Map<String, dynamic> json) {
    return MilestoneDetailScreenParams(
      episodeId: json['episodeId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      topics: json['topics'] as List<Topic>,
      milestoneId: json['milestoneId'] as int,
      startDate: json['startDate'] as String?,
      relativeStartDate: json['relativeStartDate'] as String?,
      procedureDate: json['procedureDate'] as String?,
    );
  }
}
