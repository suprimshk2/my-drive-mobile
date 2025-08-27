import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/episode/data/model/episode_response_model.dart';
import 'package:mydrivenepal/feature/tasks/constants/enums.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/feature/tasks/data/task_repo.dart';
import 'package:mydrivenepal/feature/topic/data/model/topic_response_model.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';
import 'package:mydrivenepal/shared/shared.dart';

import '../../shared/helper/episode_helper.dart';
import '../episode/data/episode_repo.dart';

class DashboardViewModel extends ChangeNotifier {
  final TaskRepo _taskRepo;
  final EpisodeRepo _episodeRepo;
  StreamSubscription<StatusModelForCallback>? _taskCompletionSubscription;

  DashboardViewModel(
      {required TaskRepo taskRepo, required EpisodeRepo episodeRepo})
      : _taskRepo = taskRepo,
        _episodeRepo = episodeRepo {}

  @override
  void dispose() {
    super.dispose();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void isScreenLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;
  set setName(String value) {
    _name = value;
    notifyListeners();
  }

  Future<void> getUserName() async {
    final name = await _taskRepo.getUserName();
    setName = name;
  }

  Future<void> loadDashboardData() async {
    isScreenLoading(true);

    try {
      await Future.wait([
        // fetchDashboardCurrentTask(),
        // fetchEpisode(),
        // getUserName(),
      ]);
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
    } finally {
      isScreenLoading(false);
    }
  }
}
