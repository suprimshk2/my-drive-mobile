import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/tasks/data/task_repo.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'constants/enums.dart';

class TaskListingViewmodel extends ChangeNotifier {
  final TaskRepo _taskRepo;
  StreamSubscription<StatusModelForCallback>? _taskCompletionSubscription;

  TaskListingViewmodel({required TaskRepo taskRepo}) : _taskRepo = taskRepo {
    _listenToTaskCompletions();
  }

  void _listenToTaskCompletions() {
    _taskCompletionSubscription =
        taskCompletionEventBus.stream.listen((statusModel) {
      removeTaskFromState(taskId: statusModel.taskId.toInt());
    });
  }

  @override
  void dispose() {
    _taskCompletionSubscription?.cancel();
    super.dispose();
  }

  // UI
  int _activeIndex = 0;

  int get activeIndex => _activeIndex;

  set activeIndex(int index) {
    _activeIndex = index;
    notifyListeners();
  }

  resetActiveIndex() {
    _activeIndex = 0;
  }

  // use cases
  Response<List<Task>> _taskListResponse = Response<List<Task>>();
  Response<List<Task>> get taskListResponse => _taskListResponse;
  set setTaskListUseCase(Response<List<Task>> response) {
    _taskListResponse = response;
    notifyListeners();
  }

  Response<List<Task>> _currentTaskListResponse = Response<List<Task>>();
  Response<List<Task>> get currentTaskListResponse => _currentTaskListResponse;
  set setCurrentTaskListUseCase(Response<List<Task>> response) {
    _currentTaskListResponse = response;
    notifyListeners();
  }

  Future<void> fetchCurrentTasks() async {
    try {
      setTaskListUseCase = Response.loading();
      setCurrentTaskListUseCase = Response.loading();
      final response =
          await _taskRepo.fetchAllTask(TaskStatus.CURRENT.displayName);
      final currentTask = filterCurrentTask(response.rows);

      setCurrentTaskListUseCase = Response.complete(currentTask);

      setTaskListUseCase = Response.complete(response.rows);
    } catch (exception) {
      setTaskListUseCase = Response.error(exception);

      setCurrentTaskListUseCase = Response.error(exception);
    }
  }

  Response<List<Task>> _dueTaskListResponse = Response<List<Task>>();
  Response<List<Task>> get dueTaskListResponse => _dueTaskListResponse;
  set setDueTaskListUseCase(Response<List<Task>> response) {
    _dueTaskListResponse = response;
    notifyListeners();
  }

  Future<void> fetchDueTasks() async {
    try {
      setTaskListUseCase = Response.loading();
      setDueTaskListUseCase = Response.loading();
      final response = await _taskRepo.fetchAllTask(TaskStatus.DUE.displayName);
      final dueTask = filterDueTask(response.rows);

      setDueTaskListUseCase = Response.complete(dueTask);
      setTaskListUseCase = Response.complete(response.rows);
    } catch (exception) {
      setTaskListUseCase = Response.error(exception);
      setDueTaskListUseCase = Response.error(exception);
    }
  }

  List<Task> filterDueTask(List<Task> data) {
    return data.where((item) => item.status == TaskStatus.DUE.name).toList();
  }

  List<Task> filterCurrentTask(List<Task> data) {
    return data.where((item) => item.status != TaskStatus.DUE.name).toList();
  }

  removeTaskFromState({
    required int taskId,
  }) {
    List<Task> dueTaskList = dueTaskListResponse.data ?? [];
    List<Task> currentTaskList = currentTaskListResponse.data ?? [];

    bool isRemovingDueTask = dueTaskList.any((item) => item.id == taskId);

    if (isRemovingDueTask) {
      dueTaskList.removeWhere((item) => item.id == taskId);

      setDueTaskListUseCase = Response.complete(dueTaskList);
    } else {
      currentTaskList.removeWhere((item) => item.id == taskId);

      setCurrentTaskListUseCase = Response.complete(currentTaskList);
    }
  }
}
