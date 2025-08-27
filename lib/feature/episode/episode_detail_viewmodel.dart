import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mydrivenepal/feature/episode/data/model/episode_detail_request_model.dart';
import 'package:mydrivenepal/feature/episode/screen/widgets/milestone_search_filters.dart';
import 'package:mydrivenepal/feature/tasks/data/model/status_model_for_callback.dart';
import 'package:mydrivenepal/shared/helper/episode_helper.dart';
import 'package:mydrivenepal/shared/shared.dart';
import 'data/model/model.dart';
import 'episode.dart';
import 'package:mydrivenepal/shared/events/task_completion_event_bus.dart';

class EpisodeDetailViewModel extends ChangeNotifier {
  final EpisodeRepo _episodeRepo;
  StreamSubscription<StatusModelForCallback>? _taskCompletionSubscription;

  EpisodeDetailViewModel({required EpisodeRepo episodeRepo})
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

  Response<TransformedEpisode> _episodeDetailResponse =
      Response<TransformedEpisode>();
  Response<TransformedEpisode> get episodeDetailResponse =>
      _episodeDetailResponse;
  set setEpisodeDetailUseCase(Response<TransformedEpisode> response) {
    _episodeDetailResponse = response;
    notifyListeners();
  }

  AdaptedEpisodeOverview? _overviewData;
  AdaptedEpisodeOverview? get overviewData => _overviewData;

  List<SupportPersonWithDesignation> _supportData = [];
  List<SupportPersonWithDesignation> get supportData => _supportData;

  String getMilestoneDisplayDate(AdaptedMilestone milestone) {
    if (isNotEmpty(milestone.relativeStartDate) &&
        milestone.relativeStartDate != "N/A") {
      return milestone.relativeStartDate!;
    } else if (isNotEmpty(milestone.procedureDate) &&
        milestone.procedureDate != "N/A") {
      return milestone.procedureDate!;
    } else if (isNotEmpty(milestone.startDate) &&
        milestone.startDate != "N/A") {
      return milestone.startDate!;
    } else {
      return 'N/A';
    }
  }

  SupportPersonWithDesignation? get careCoordinator => _supportData.firstWhere(
        (person) => person.designation == 'Care Co-ordinator',
      );

  SupportPersonWithDesignation? get engagementSpecialist =>
      _supportData.firstWhere(
        (person) => person.designation == 'Engagement Specialist',
      );

  AdaptedEpisodeOverview _formatOverviewData(TransformedEpisode episodeData) {
    final episodeOverview = EpisodeOverview(
      procedureDate: episodeData.procedureDate,
      facility: episodeData.facility,
      provider: episodeData.provider,
      clinic: episodeData.clinic,
      benefitPeriod: BenefitPeriod(
        benefitStartDate: episodeData.benefitStartDate,
        benefitEndDate: episodeData.benefitEndDate,
      ),
      createdDate: episodeData.createdAt.toString(),
    );

    return episodeOverview.toAdapted();
  }

  String? searchQuery;

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  bool get isSearchQueryForMilestone => _isSearchQueryForMilestone;
  bool _isSearchQueryForMilestone = false;

  set searchQueryForMilestone(bool value) {
    _isSearchQueryForMilestone = value;
    notifyListeners();
  }

  EpisodeStatusFilter _episodeStatusFilter = EpisodeStatusFilter.ALL;
  EpisodeStatusFilter get episodeStatusFilter => _episodeStatusFilter;
  set episodeStatusFilter(EpisodeStatusFilter value) {
    _episodeStatusFilter = value;
    notifyListeners();
  }

  Response<List<AdaptedMilestone>> _milestoneSearchUseCase =
      Response<List<AdaptedMilestone>>();
  Response<List<AdaptedMilestone>> get milestoneSearchUseCase =>
      _milestoneSearchUseCase;
  set setMilestoneSearchUseCase(Response<List<AdaptedMilestone>> response) {
    _milestoneSearchUseCase = response;
    notifyListeners();
  }

  Future<void> fetchEpisodeDetail(
      {required String episodeId, required bool isMilestoneSearch}) async {
    final String? episodeStatus =
        (episodeStatusFilter == EpisodeStatusFilter.ALL)
            ? null
            : episodeStatusFilter.value;

    try {
      if (isMilestoneSearch) {
        _milestoneSearchUseCase = Response.loading();
      } else {
        setEpisodeDetailUseCase = Response.loading();
      }

      final episodeDetailRequestModel = EpisodeDetailRequestModel(
        keyword: searchQuery,
        status: episodeStatus,
      );

      debugPrint(
          'debug: event customer ${episodeDetailRequestModel.toJson().toString()}'); //TODO: refactor later

      final response = await _episodeRepo.fetchEpisodeDetail(episodeId,
          queryParams: episodeDetailRequestModel.toJson());

      if (!isMilestoneSearch) {
        final transformedEpisode =
            TransformedEpisode.transformEpisodes(response);
        _overviewData = _formatOverviewData(transformedEpisode);
        _supportData = EpisodeHelper.formatSupportData(transformedEpisode);

        setEpisodeDetailUseCase = Response.complete(transformedEpisode);
      }
      response.milestones.sort((a, b) => a.sequence - b.sequence);
      setMilestoneSearchUseCase = Response.complete(response.milestones);
    } catch (exception) {
      if (isMilestoneSearch) {
        setMilestoneSearchUseCase = Response.error(exception);
      } else {
        setEpisodeDetailUseCase = Response.error(exception);
      }
    }
  }

  onTaskCompleted({
    required StatusModelForCallback statusModelForCallback,
  }) {
    TransformedEpisode? episode = episodeDetailResponse.data;

    if (episode != null && episode.id == statusModelForCallback.episodeId) {
      episode = episode.copyWith(
        status: statusModelForCallback.episodeStatus,
        milestones: episode.milestones.map((milestone) {
          if (milestone.id == statusModelForCallback.milestoneId) {
            return milestone.copyWith(
              status: statusModelForCallback.milestoneStatus,
            );
          }
          return milestone;
        }).toList(),
      );

      setEpisodeDetailUseCase = Response.complete(episode);
    }
  }
}
