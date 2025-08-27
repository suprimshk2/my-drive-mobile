import '../../../data/model/fetch_list_response.dart';
import '../episode.dart';

class EpisodeRepoImpl implements EpisodeRepo {
  final EpisodeRemote _episodeRemote;

  EpisodeRepoImpl({
    required EpisodeRemote episodeRemote,
  }) : _episodeRemote = episodeRemote;

  @override
  Future<FetchListResponse<EpisodeItem>> fetchEpisodeList() async {
    final response = await _episodeRemote.fetchEpisodeList();
    return response;
  }

  @override
  Future<EpisodeItem> fetchEpisodeDetail(String episodeId,
      {Map<String, dynamic>? queryParams}) async {
    final response = await _episodeRemote.fetchEpisodeDetail(episodeId,
        queryParams: queryParams);
    return response;
  }
}
