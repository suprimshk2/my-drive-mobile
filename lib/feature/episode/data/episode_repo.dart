import '../../../data/model/fetch_list_response.dart';
import 'model/episode_response_model.dart';

abstract class EpisodeRepo {
  Future<FetchListResponse<EpisodeItem>> fetchEpisodeList();
  Future<EpisodeItem> fetchEpisodeDetail(String episodeId,
      {Map<String, dynamic>? queryParams});
}
