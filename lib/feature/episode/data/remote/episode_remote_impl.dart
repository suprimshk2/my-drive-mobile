import 'package:mydrivenepal/data/remote/api_client.dart';

import '../../../../data/model/fetch_list_response.dart';
import '../../../../shared/constant/remote_api_constant.dart';

import '../model/episode_response_model.dart';
import 'episode_remote.dart';

class EpisodeRemoteImpl implements EpisodeRemote {
  final ApiClient _apiClient;

  EpisodeRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchListResponse<EpisodeItem>> fetchEpisodeList() async {
    final response = await _apiClient.get(
      RemoteAPIConstant.EPISODE_LIST,
    );
    final adoptResponse = FetchListResponse<EpisodeItem>.fromJson(
        response.data, EpisodeItem.fromJsonList);
    return adoptResponse;
  }

  @override
  Future<EpisodeItem> fetchEpisodeDetail(String episodeId,
      {Map<String, dynamic>? queryParams}) async {
    final response = await _apiClient.get(
      RemoteAPIConstant.EPISODE_DETAIL.replaceAll(':episodeId', episodeId),
      queryParameters: queryParams,
    );
    try {
      final adoptResponse = EpisodeItem.fromJson(response.data);
      return adoptResponse;
    } catch (e) {
      throw e;
    }
  }
}
