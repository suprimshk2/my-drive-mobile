import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';
import 'data/model/model.dart';
import 'data/topic_repo.dart';

class TopicViewModel extends ChangeNotifier {
  final TopicRepo _topicRepo;
  StreamSubscription<StatusModelForCallback>? _taskCompletionSubscription;

  TopicViewModel({required TopicRepo topicRepo}) : _topicRepo = topicRepo {
    _listenToTaskCompletions();
  }

  void _listenToTaskCompletions() {
    _taskCompletionSubscription =
        taskCompletionEventBus.stream.listen((statusModel) {
      onTaskCompleted(statusModelForCallback: statusModel);
    });
  }

  @override
  void dispose() {
    _taskCompletionSubscription?.cancel();
    super.dispose();
  }

  bool isScrolled = false;
  set isScrolledScreen(bool value) {
    isScrolled = value;
    notifyListeners();
  }

  void _sortData(List<Topic> topics) {
    //TODO: use later
    topics
      ..sort((a, b) => a.sequence!.compareTo(b.sequence!))
      ..forEach((topic) =>
          topic.tasks?.sort((a, b) => a.sequence!.compareTo(b.sequence!)));
  }

  Response<List<Topic>> _topicListUseCase = Response<List<Topic>>();
  Response<List<Topic>> get topicListUseCase => _topicListUseCase;
  set topicListUseCase(Response<List<Topic>> response) {
    _topicListUseCase = response;
    notifyListeners();
  }

  Future<void> fetchTopicList(
      {required String milestoneId, required String episodeId}) async {
    try {
      topicListUseCase = Response.loading();
      final response = await _topicRepo.fetchTopicList(
        milestoneId: milestoneId,
        episodeId: episodeId,
      );

      topicListUseCase = Response.complete(response.rows);
    } catch (exception) {
      topicListUseCase = Response.error(exception);
    }
  }

  onTaskCompleted({
    required StatusModelForCallback statusModelForCallback,
  }) {
    List<Topic> listOfTopics = topicListUseCase.data ?? [];

    final topicIndex = listOfTopics
        .indexWhere((topic) => topic.id == statusModelForCallback.topicId);

    if (topicIndex != -1) {
      final topic = listOfTopics[topicIndex];

      final updatedTopic = topic.copyWith(
        status: statusModelForCallback.topicStatus,
        tasks: topic.tasks?.map((task) {
          if (task.id == statusModelForCallback.taskId) {
            return task.copyWith(
              status: statusModelForCallback.taskStatus,
            );
          }
          return task;
        }).toList(),
      );

      listOfTopics.removeAt(topicIndex);

      listOfTopics.insert(topicIndex, updatedTopic);

      topicListUseCase = Response.complete(listOfTopics);
    }
  }
}
