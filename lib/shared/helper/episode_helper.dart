import '../../feature/episode/episode.dart';

class EpisodeHelper {
  static List<SupportPersonWithDesignation> formatSupportData(
      EpisodeItem episodeData) {
    final Map<int, SupportPersonWithDesignation> supportMap = {};

    // Add Care Coordinator if exists
    if (episodeData.cc != null) {
      supportMap[episodeData.cc!.id] =
          SupportPersonWithDesignation.fromCc(episodeData.cc!);
    }

    // Add Engagement Specialist if exists (won't duplicate if same ID)
    if (episodeData.es != null) {
      supportMap[episodeData.es!.id] =
          SupportPersonWithDesignation.fromEs(episodeData.es!);
    }

    return supportMap.values.toList();
  }
}
