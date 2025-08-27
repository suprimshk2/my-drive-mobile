import 'package:mydrivenepal/data/remote/api_client.dart';

import '../../../../data/model/fetch_list_response.dart';
import '../../../../shared/constant/remote_api_constant.dart';

import '../model/model.dart';
import 'topic_remote.dart';

class TopicRemoteImpl implements TopicRemote {
  final ApiClient _apiClient;

  TopicRemoteImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchListResponse<Topic>> fetchTopicList(
      {required String milestoneId, required String episodeId}) async {
    final response = await _apiClient.get(
      RemoteAPIConstant.TOPIC_LIST
          .replaceAll(':milestoneId', milestoneId)
          .replaceAll(':episodeId', episodeId),
    );
    final adoptResponse =
        FetchListResponse<Topic>.fromJson(response.data, Topic.fromJsonList);
    return adoptResponse;
  }
}
