import '../../../../data/model/fetch_list_response.dart';
import '../../episode.dart';

abstract class EpisodeRemote {
  Future<FetchListResponse<EpisodeItem>> fetchEpisodeList();
  Future<EpisodeItem> fetchEpisodeDetail(String episodeId,
      {Map<String, dynamic>? queryParams});
}
