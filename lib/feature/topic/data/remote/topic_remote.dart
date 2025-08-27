import '../../../../data/model/model.dart';
import '../model/model.dart';

abstract class TopicRemote {
  Future<FetchListResponse<Topic>> fetchTopicList(
      {required String milestoneId, required String episodeId});
}
