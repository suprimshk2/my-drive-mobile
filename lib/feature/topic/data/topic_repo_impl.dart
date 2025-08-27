import '../../../data/model/fetch_list_response.dart';
import 'model/model.dart';
import 'remote/remote.dart';
import 'topic_repo.dart';

class TopicRepoImpl implements TopicRepo {
  final TopicRemote _topicRemote;

  TopicRepoImpl({
    required TopicRemote topicRemote,
  }) : _topicRemote = topicRemote;

  @override
  Future<FetchListResponse<Topic>> fetchTopicList(
      {required String milestoneId, required String episodeId}) async {
    final response = await _topicRemote.fetchTopicList(
      milestoneId: milestoneId,
      episodeId: episodeId,
    );
    return response;
  }
}
