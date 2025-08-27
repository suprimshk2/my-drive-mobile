import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';
import 'episode.dart';

class EpisodeViewModel extends ChangeNotifier {
  final EpisodeRepo _episodeRepo;
  StreamSubscription<StatusModelForCallback>? _taskCompletionSubscription;

  EpisodeViewModel({required EpisodeRepo episodeRepo})
      : _episodeRepo = episodeRepo {
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

  Response<List<TransformedEpisode>> _episodeListResponse =
      Response<List<TransformedEpisode>>();
  Response<List<TransformedEpisode>> get episodeListResponse =>
      _episodeListResponse;
  set setEpisodeListUseCase(Response<List<TransformedEpisode>> response) {
    _episodeListResponse = response;
    notifyListeners();
  }

  Future<void> fetchEpisodeList() async {
    try {
      setEpisodeListUseCase = Response.loading();
      final response = await _episodeRepo.fetchEpisodeList();

      final transformedEpisodeItems = response.rows
          .map((EpisodeItem episode) =>
              TransformedEpisode.transformEpisodes(episode))
          .toList();
      final activeEpisodes =
          TransformedEpisode.filterActiveEpisode(response.rows);

      setEpisodeListUseCase = Response.complete(transformedEpisodeItems);
    } catch (exception) {
      setEpisodeListUseCase = Response.error(exception);
    }
  }

  onTaskCompleted({
    required StatusModelForCallback statusModelForCallback,
  }) {
    List<TransformedEpisode> listOfEpisodes = episodeListResponse.data ?? [];

    final episodeIndex = listOfEpisodes.indexWhere(
        (episode) => episode.id == statusModelForCallback.episodeId);

    if (episodeIndex != -1) {
      final episode = listOfEpisodes[episodeIndex];

      final updatedEpisode = episode.copyWith(
        status: statusModelForCallback.episodeStatus,
      );

      listOfEpisodes.removeAt(episodeIndex);

      listOfEpisodes.insert(episodeIndex, updatedEpisode);

      setEpisodeListUseCase = Response.complete(listOfEpisodes);
    }
  }
}
